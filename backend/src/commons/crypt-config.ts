import * as crypto from 'crypto';

const ENCRYPTION_KEY = (process.env.ENCRYPTION_KEY || 'S3cur3Encr1pt10nK3y@2024!#AnTr0p').padEnd(32, '0');
const IV_LENGTH = 16; // Para AES, esto es siempre 16

function toUrlSafeBase64(base64: string): string {
  return base64.replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
}

function fromUrlSafeBase64(urlSafe: string): string {
  urlSafe = urlSafe.replace(/-/g, '+').replace(/_/g, '/');
  while (urlSafe.length % 4) {
    urlSafe += '=';
  }
  return urlSafe;
}

export function encrypt(text: string): string {
  const iv = crypto.randomBytes(IV_LENGTH);
  const cipher = crypto.createCipheriv('aes-256-cbc', Buffer.from(ENCRYPTION_KEY), iv);
  let encrypted = cipher.update(text, 'utf8', 'base64');
  encrypted += cipher.final('base64');
  return toUrlSafeBase64(iv.toString('base64')) + '.' + toUrlSafeBase64(encrypted);
}

export function decrypt(text: string): string {
  const textParts = text.split('.');
  const iv = Buffer.from(fromUrlSafeBase64(textParts[0]), 'base64');
  const encryptedText = fromUrlSafeBase64(textParts[1]);
  const decipher = crypto.createDecipheriv('aes-256-cbc', Buffer.from(ENCRYPTION_KEY), iv);
  let decrypted = decipher.update(encryptedText, 'base64', 'utf8');
  decrypted += decipher.final('utf8');
  return decrypted;
}