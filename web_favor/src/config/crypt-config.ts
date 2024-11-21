import { ref } from 'vue'
import CryptoJS from 'crypto-js'

export function useEncryption(customKey?: string) {
    const ENCRYPTION_KEY = (customKey || 'S3cur3Encr1pt10nK3y@2024!#AnTr0p').padEnd(32, '0')
    const IV_LENGTH = 16

    const error = ref<string | null>(null)
    const isProcessing = ref(false)

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

    const decrypt = (encryptedText: string): string | null => {
        try {
            isProcessing.value = true
            error.value = null

            if (!encryptedText) {
                throw new Error('El texto encriptado no puede estar vacío')
            }

            const textParts = encryptedText.split('.')
            if (textParts.length !== 2) {
                throw new Error('Formato de texto encriptado inválido')
            }

            // Obtener IV y texto encriptado
            const iv = CryptoJS.enc.Base64.parse(fromUrlSafeBase64(textParts[0]))
            const encryptedData = fromUrlSafeBase64(textParts[1])

            // Crear la clave como WordArray
            const key = CryptoJS.enc.Utf8.parse(ENCRYPTION_KEY)

            // Desencriptar
            const decrypted = CryptoJS.AES.decrypt(encryptedData, key, {
                iv: iv,
                mode: CryptoJS.mode.CBC,
                padding: CryptoJS.pad.Pkcs7
            })

            // Convertir el resultado a UTF-8
            const utf8Text = decrypted.toString(CryptoJS.enc.Utf8)

            // Validar que el resultado sea UTF-8 válido
            if (!utf8Text) {
                throw new Error('Error al decodificar el texto: formato inválido')
            }

            return utf8Text
        } catch (e) {
            error.value = e instanceof Error ? e.message : 'Error en la desencriptación'
            console.error('Error completo:', e)
            return null
        } finally {
            isProcessing.value = false
        }
    }

    const encrypt = (text: string): string | null => {
        try {
            isProcessing.value = true
            error.value = null

            if (!text) {
                throw new Error('El texto a encriptar no puede estar vacío')
            }

            // Generar IV aleatorio
            const iv = CryptoJS.lib.WordArray.random(IV_LENGTH)

            // Crear la clave como WordArray
            const key = CryptoJS.enc.Utf8.parse(ENCRYPTION_KEY)

            // Encriptar
            const encrypted = CryptoJS.AES.encrypt(text, key, {
                iv: iv,
                mode: CryptoJS.mode.CBC,
                padding: CryptoJS.pad.Pkcs7
            })

            // Generar resultado en el formato correcto
            const result = toUrlSafeBase64(iv.toString(CryptoJS.enc.Base64)) + '.' +
                toUrlSafeBase64(encrypted.toString())

            return result
        } catch (e) {
            error.value = e instanceof Error ? e.message : 'Error en la encriptación'
            console.error('Error completo:', e)
            return null
        } finally {
            isProcessing.value = false
        }
    }

    return {
        encrypt,
        decrypt,
        error,
        isProcessing
    }
}