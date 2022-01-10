class Product < ApplicationRecord
  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details
  has_one_attached :image
  belongs_to :category

  accepts_nested_attributes_for :category

  ransack_alias :product, :name_or_description

  ransacker :created_at, type: :date do
    Arel.sql("date(products.created_at)")
  end

  scope :sort_by_name, ->(keyword){where "name LIKE ?", "%#{keyword}%"}
  scope :order_by, ->(keyword){order keyword}
  scope :filter_by_category, ->(category){where category_id: category}
  scope :filter_by_price, ->(order){order(price: order)}
  scope :filter_by_rate, ->(order){order(rating: order)}
  scope :filter_by_name, ->(order){order(name: order)}
  scope :filter_by_type,
        (lambda do |type|
          joins(:category).where("categories.parent_id = :type", type: type)
        end)

  OPTION = {
    all: 1,
    oldest: 2,
    newest: 3,
    price_asc: 4,
    price_desc: 5
  }.freeze

  PRO_ATS = %w(name price rating description image quantity category_id).freeze

  validates :name, presence: true,
    length: {maximum: Settings.length.len_50}
  validates :price, presence: true,
    numericality: {only_decimal: true}
  validates :description, presence: true
  validates :quantity, presence: true,
    numericality: {only_integer: true, greater_than: Settings.min.quantity}
  validates :image, content_type:
   {in: %w(image/jpeg image/gif image/png),
    message: I18n.t("user.img_valid")},
   size: {less_than: Settings.length.len_5.megabytes,
          message: I18n.t("user.img_mess")}

  def display_image_admin
    image.variant resize_to_limit: [300, 200]
  end

  def display_image_home
    image.variant resize_to_limit: [267, 268]
  end

  def display_img_detail
    image.variant resize_to_limit: [377, 377]
  end

  class << self
    def import_file file
      ActiveRecord::Base.transaction do
        spreadsheet = Roo::Spreadsheet.open file
        rows = read_file spreadsheet
        products_valid = []
        products_invalid = []
        get_list_product rows, products_invalid, products_valid
        import! products_valid
        {
          errors: products_invalid.count,
          successes: products_valid.count,
          updates: rows.count - products_invalid.count - products_valid.count
        }
      end
    rescue ActiveRecord::RecordInvalid
      {}
    end

    def read_file spreadsheet
      header = spreadsheet.row(1)
      rows = []
      (2..spreadsheet.last_row).each do |i|
        row = new [header, spreadsheet.row(i)].transpose.to_h
        rows << row
      end
      rows
    end

    def get_list_product rows, products_invalid, products_valid
      list_product = []
      rows.each do |item|
        item.quantity = item.quantity.to_i
        list_product << item
      end

      check_product? list_product, products_invalid, products_valid
    end

    def check_product? products, products_invalid, products_valid
      products.each do |product|
        if product.valid?
          @item = Product.find_by(name: product.name)
          if @item
            @item.update quantity: @item.quantity + product.quantity
          else
            products_valid << product
          end
        else
          products_invalid << product
        end
      end
    end
  end

  def self.ransackable_attributes auth_object = nil
    if auth_object == :admin
      super
    else
      super & %w(product name description price created_at)
    end
  end

  def self.ransackable_scopes auth_object = nil
    if auth_object == :admin
      %i(filter_by_category filter_by_type sort_by_name order_by
        filter_by_price filter_by_name filter_by_rate)
    else
      # @q = Product.ransack({filter_by_rate: "desc"}, {auth_object: :admin})
      %i(filter_by_category filter_by_type filter_by_price filter_by_name)
    end
  end
end
