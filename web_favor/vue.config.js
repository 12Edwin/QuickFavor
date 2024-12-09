const { defineConfig } = require('@vue/cli-service');

module.exports = defineConfig({
  transpileDependencies: true,
  pwa: {
    name: 'Web QuickFavor',
    short_name: 'QuickFavorWeb',
    themeColor: '#42b983',
    msTileColor: '#000000',
    manifestPath: 'manifest.json',
    workboxPluginMode: 'InjectManifest', // Cambiar a InjectManifest para usar SW personalizado
    workboxOptions: {
      swSrc: 'src/service-worker.ts', // Ruta a tu SW
      swDest: 'service-worker.js' // Nombre de salida
    }
  }
});