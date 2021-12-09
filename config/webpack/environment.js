const { environment } = require('@rails/webpacker')

const webp ack = require("webpack")

environment.plugins.prepend(
  "Provide",
  new webpack.ProvidePlugin({
    $: "jquery",
    jQuery: "jquery",
    Popper: ["popper.js", "default"]
  })
);

module.exports = environment
