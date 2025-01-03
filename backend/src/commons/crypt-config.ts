import CryptoJS from 'crypto-js'

const ENCRYPTION_KEY = ('S3cur3Encr1pt10nK3y@2024!#AnTr0p').padEnd(32, '0')
const IV_LENGTH = 16

const toUrlSafeBase64 = (base64: string): string => {
  return base64.replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '')
}

const fromUrlSafeBase64 = (urlSafe: string): string => {
  let result = urlSafe.replace(/-/g, '+').replace(/_/g, '/')
  while (result.length % 4) {
    result += '='
  }
  return result
}

export const decrypt = (encryptedText: string): string => {
  try {
    if (!encryptedText) {
      throw new Error('El texto encriptado no puede estar vacío')
    }

    const textParts = encryptedText.split('.')
    if (textParts.length !== 2) {
      throw new Error('Formato de texto encriptado inválido')
    }

    const iv = CryptoJS.enc.Base64.parse(fromUrlSafeBase64(textParts[0]))
    const encryptedData = fromUrlSafeBase64(textParts[1])
    const key = CryptoJS.enc.Utf8.parse(ENCRYPTION_KEY)

    // Desencriptar
    const decrypted = CryptoJS.AES.decrypt(encryptedData, key, {
      iv: iv,
      mode: CryptoJS.mode.CBC,
      padding: CryptoJS.pad.Pkcs7
    })

    const utf8Text = decrypted.toString(CryptoJS.enc.Utf8)
    if (!utf8Text) {
      throw new Error('Error al decodificar el texto: formato inválido')
    }

    return utf8Text
  } catch (e) {
    console.error('Error completo:', e)
    return ''
  }
}

export const encrypt = (text: string): string => {
  try {
    if (!text) {
      throw new Error('El texto a encriptar no puede estar vacío')
    }

    const iv = CryptoJS.lib.WordArray.random(IV_LENGTH)
    const key = CryptoJS.enc.Utf8.parse(ENCRYPTION_KEY)

    // Encriptar
    const encrypted = CryptoJS.AES.encrypt(text, key, {
      iv: iv,
      mode: CryptoJS.mode.CBC,
      padding: CryptoJS.pad.Pkcs7
    })

    const result = toUrlSafeBase64(iv.toString(CryptoJS.enc.Base64)) + '.' +
        toUrlSafeBase64(encrypted.toString())

    return result
  } catch (e) {
    console.error('Error completo:', e)
    return ''
  }
}