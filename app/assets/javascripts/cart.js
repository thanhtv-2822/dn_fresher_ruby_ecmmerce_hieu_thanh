$(document).ready(function(){
  $(".qty").change(function () {
    var id = $(this).parent().parent().find(".product-id").val()
    var quantity = $(this).val();
    $.ajax({
      url: "/carts/update_cart/" + id,
      method: "PUT",
      data: {quantity: quantity}
    })
  })
  $(".review").click(function(){
    var id = $(this).parent().parent().find(".product-id").val()
    var rate = $(this)[0].getAttribute("value")
    var parent = $(this).parent()[0].children
    $.ajax({
      url: "/carts/update_rating/" + id,
      method: "PUT",
      data: {rating: rate}
    })
    for(let i = 0; i < parent.length; i++){
      if (i+1 > rate){
        parent[i].classList.remove("checked")
      }
      else parent[i].classList.add("checked")
    }
  })
})
