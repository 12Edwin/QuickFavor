const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true,
  pwa: {
    name: 'QuickFavor',
    themeColor: '#4DBA87',
    msTileColor: '#000000',
    appleMobileWebAppCapable: 'yes',
    appleMobileWebAppStatusBarStyle: 'black',

    workboxPluginMode: 'GenerateSW',
    workboxOptions: {
      // Eliminar precacheManifestFilename
      // Usar runtimeCaching para estrategias de caché
      runtimeCaching: [
        {
          urlPattern: /\.(js|css|html)$/,
          handler: 'CacheFirst',
          options: {
            cacheName: 'static-resources',
            expiration: {
              maxEntries: 60,
              maxAgeSeconds: 30 * 24 * 60 * 60
            }
          }
        },
        {
          urlPattern: /\.(png|jpg|jpeg|gif|svg)$/,
          handler: 'CacheFirst',
          options: {
            cacheName: 'images',
            expiration: {
              maxEntries: 50,
              maxAgeSeconds: 30 * 24 * 60 * 60
            }
          }
        }
      ],

      // Usar additionalManifestEntries en lugar de precacheManifestFilename
      // additionalManifestEntries: [],

      // Archivos a excluir
      exclude: [
        /\.map$/,
        /^manifest.*\\.js$/
      ]
    }
  }
})
