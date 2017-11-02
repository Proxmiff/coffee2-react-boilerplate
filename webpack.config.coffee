path = require 'path'
webpack = require 'webpack'
HtmlWebpackPlugin = require 'html-webpack-plugin'

pkg = require './package.json'

pluginSet = [
  new HtmlWebpackPlugin
    template: './app/app.html'
    filename: 'index.html'
    inject: 'body'
    minify:
      collapseWhitespace: true
      removeScriptTypeAttributes: true
]

if process.env.NODE_ENV == 'production'
  pluginSet.push new webpack.DefinePlugin
    'process.env': NODE_ENV: JSON.stringify process.env.NODE_ENV
  pluginSet.push new webpack.optimize.UglifyJsPlugin
    comments: false

module.exports =
  devServer:
    inline: true
    host: '0.0.0.0'
    port: 8292
    historyApiFallback: true
  resolve:
    extensions: ['*', '.js', '.coffee', '.cs2x']
    modules: ['node_modules']
    alias:
      components: path.resolve 'app/components'
      views: path.resolve 'app/views'
  entry: './app/app.cs2x'
  output:
    path: path.resolve 'dist'
    filename: "#{do pkg.name.toLowerCase}-#{pkg.version}.js"
    publicPath: '/'
  module:
    loaders: [
      test: /\.js$/
      loader: 'babel-loader'
      exclude: /node_modules/
    ,
      test: /\.cs2x$/,
      loaders: ['babel-loader', 'coffee-loader']
      exclude: /node_modules/
    ,
      test: /\.coffee$/,
      loader: 'coffee-loader'
      exclude: /node_modules/
    ,
      test: /\.less$/,
      loaders: ['style-loader', 'css-loader', 'less-loader']
      exclude: /node_modules/
    ]
  plugins: pluginSet
