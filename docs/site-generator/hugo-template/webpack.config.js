"use strict";

const path = require('path');
const webpack = require('webpack');
const merge = require('webpack-merge');
const autoprefixer = require('autoprefixer');
const extractTextPlugin = require('extract-text-webpack-plugin');

const IS_PRODUCTION = process.env.npm_lifecycle_event === 'build';

const baseConf = {
    entry: [
        './src/sass/app.scss',
        './src/js/index.js',
    ],
    output: {
        path: './static',
        filename: 'js/bundle.js',
    },
    module: {
        loaders: [
        {
            test: /.js?$/,
            loader: 'babel-loader',
            exclude: /node_modules/,
            query: {
                presets: ['es2015']
            }
        }, {
            test: /\.(eot|ttf|woff|svg|png|gif|jpg|jpeg)$/,
            loaders: ['file']
        },
        {
            test: /(?:\.scss|\.css)$/,
            loader: extractTextPlugin.extract(
                'style-loader',
                'css!sass?',
                ['css-loader', 'postcss-loader']
            )
        }
        ]
    },
    resolve: {
        modulesDirectories: ['node_modules'],
        extensions: ['', '.js']
    },
    postcss: [autoprefixer({ browsers: ['last 2 versions'] })],
}

const productionConf = {
    plugins: [
        new webpack.optimize.OccurenceOrderPlugin(),
        new webpack.DefinePlugin({
            'process.env': {
                'NODE_ENV': JSON.stringify('production')
            }
        }),
        new extractTextPlugin('css/style.css', { allChunks: true }),
        new webpack.optimize.UglifyJsPlugin({
            compress: {
                warnings: false
            }
        })
    ]
}

const developmentConf = {
    devtool: 'source-map',
    devServer: {
        contentBase: 'static/',
    },
    plugins: [
        new extractTextPlugin('css/style.css', { allChunks: true }),
    ],
}

module.exports = merge(baseConf, IS_PRODUCTION ? productionConf : developmentConf);
