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
      // Estrategia de caché para documentos HTML (prioridad para la página principal)
      runtimeCaching: [
        {
          urlPattern: /\.html$/,
          handler: 'NetworkFirst', // Intenta red primero, sino usa caché
          options: {
            cacheName: 'html-cache',
            networkTimeoutSeconds: 3, // Timeout de 3 segundos
            expiration: {
              maxEntries: 10,
              maxAgeSeconds: 24 * 60 * 60 // 1 día
            },
            cacheableResponse: {
              statuses: [0, 200] // Cachear respuestas 0 y 200
            }
          }
        },
        // Caché para archivos estáticos
        {
          urlPattern: /\.(js|css|png|jpg|jpeg|svg)$/,
          handler: 'CacheFirst', // Caché primero
          options: {
            cacheName: 'static-assets',
            expiration: {
              maxEntries: 60,
              maxAgeSeconds: 30 * 24 * 60 * 60 // 30 días
            }
          }
        }
      ],

      // Precachear archivos críticos
      navigateFallback: 'index.html',
      navigateFallbackDenylist: [/\.(js|css|png|jpg|jpeg|svg)$/],

      // Excluir mapas de fuente y manifiestos
      exclude: [
        /\.map$/,
        /^manifest.*\\.js$/
      ],

      // Archivos a incluir en la precarga
      skipWaiting: true, // Actualizar Service Worker inmediatamente
      clientsClaim: true // Controlar clientes inmediatamente
    }
  }
})
