/*
 * @Description: 
 * @Author: 
 * @Date: 2024-01-14 20:02:29
 */
module.exports = {
    lintOnSave: false,
    productionSourceMap: false,
    parallel: false,
    configureWebpack: {
        performance: {
            hints: false
        }
    },
    devServer: {
        //host: "139.224.72.73",
        host: "localhost",
        port: 8082,
        https: false,
        //proxy: "http://localhost:80",
        proxy: {
            '/': {
                //target: 'http://139.224.72.73:9281',
                target: 'http://localhost:9092',
                changeOrigin: true,
            },
        },
        overlay: { // Disable ESLint
            warning: false,
            errors: false
        },
    }
}
// Set proxy to resolve CORS