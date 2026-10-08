const test = require('firebase-functions-test')();
const admin = require('firebase-admin');
const { assert } = require('chai');

// Note: In a real environment, we would use @firebase/rules-unit-testing
// For this environment, we are simulating the logic tests for the regexes
// and rule logic to verify the logic before deploying to the emulator.

const validators = {
  isHttpsUrl: (url) => {
    if (typeof url !== 'string' || url.length > 300) return false;
    const regex = /^https:\/\/[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\.[a-zA-Z]{2,}[^\s\x00-\x1F]*$/;
    return regex.test(url);
  },
  isHandle: (val) => {
    if (typeof val !== 'string' || val.length > 30) return false;
    const regex = /^[a-zA-Z0-9._]*[a-zA-Z0-9][a-zA-Z0-9._]*$/;
    return regex.test(val);
  },
  isInstagram: (val) => {
    if (typeof val !== 'string') return false;
    if (val === '') return true;
    if (validators.isHandle(val)) return true;
    if (val.length > 300) return false;
    const regex = /^https:\/\/(www\.)?instagram\.com\/[a-zA-Z0-9_.]{1,30}\/?(\?[^\s\x00-\x1F]*)?$/;
    return regex.test(val);
  },
  isTikTok: (val) => {
    if (typeof val !== 'string') return false;
    if (val === '') return true;
    if (validators.isHandle(val)) return true;
    if (val.length > 300) return false;
    const regex = /^https:\/\/(www\.)?tiktok\.com\/@[a-zA-Z0-9_.]{1,30}\/?(\?[^\s\x00-\x1F]*)?$/;
    return regex.test(val);
  },
  isYouTube: (val) => {
    if (typeof val !== 'string') return false;
    if (val === '') return true;
    if (validators.isHandle(val)) return true;
    if (val.length > 300) return false;
    const patterns = [
      /^https:\/\/(www\.)?youtube\.com\/@[a-zA-Z0-9_.]{1,30}\/?(\?[^\s\x00-\x1F]*)?$/,
      /^https:\/\/(www\.)?youtube\.com\/c\/[a-zA-Z0-9_.]{1,30}\/?(\?[^\s\x00-\x1F]*)?$/,
      /^https:\/\/(www\.)?youtube\.com\/channel\/[a-zA-Z0-9_-]{24}\/?(\?[^\s\x00-\x1F]*)?$/,
      /^https:\/\/(www\.)?youtube\.com\/user\/[a-zA-Z0-9_.]{1,30}\/?(\?[^\s\x00-\x1F]*)?$/,
      /^https:\/\/youtu\.be\/[a-zA-Z0-9_-]{11}\/?(\?[^\s\x00-\x1F]*)?$/
    ];
    return patterns.some(re => re.test(val));
  }
};

// Re-bind to local scope for the test block
const v = validators;

describe('Security Validators', () => {
  describe('isHttpsUrl', () => {
    const valid = ['https://google.com', 'https://a.io', 'https://test.com/path', 'https://sub.dom.com?q=1', 'https://site.org#top'];
    const invalid = ['http://google.com', 'ftp://site.com', 'https:// evil.com', 'javascript:alert(1)', 'https://.com'];

    valid.forEach(url => it(`should accept ${url}`, () => assert.strictEqual(v.isHttpsUrl(url), true)));
    invalid.forEach(url => it(`should reject ${url}`, () => assert.strictEqual(v.isHttpsUrl(url), false)));
  });

  describe('isInstagram', () => {
    const valid = ['champ_dance', 'https://instagram.com/user', 'https://www.instagram.com/u', '', 'user.name_123'];
    const invalid = ['@user', 'https://tiktok.com/u', 'https://instagram.com.evil.com', 'https:// evil.com', '..', 'a'.repeat(45)];

    valid.forEach(val => it(`should accept ${val}`, () => assert.strictEqual(v.isInstagram(val), true)));
    invalid.forEach(val => it(`should reject ${val}`, () => assert.strictEqual(v.isInstagram(val), false)));
  });

  describe('isTikTok', () => {
    const valid = ['dance_star', 'https://tiktok.com/@u', 'https://www.tiktok.com/@u', '', 'user.name_123'];
    const invalid = ['@user', 'https://instagram.com/u', 'https://tiktok.com.evil.com', 'https:// tiktok.com/@u', '_', 'a'.repeat(45)];

    valid.forEach(val => it(`should accept ${val}`, () => assert.strictEqual(v.isTikTok(val), true)));
    invalid.forEach(val => it(`should reject ${val}`, () => assert.strictEqual(v.isTikTok(val), false)));
  });

  describe('isYouTube', () => {
    const valid = ['yt_artist', 'https://youtube.com/@u', 'https://youtu.be/abcdefghijk', 'https://www.youtube.com/c/u', ''];
    const invalid = ['@user', 'https://tiktok.com/u', 'https://youtube.com.evil.com', 'https:// youtube.com/', '.', 'https://youtu.be/short'];

    valid.forEach(val => it(`should accept ${val}`, () => assert.strictEqual(v.isYouTube(val), true)));
    invalid.forEach(val => it(`should reject ${val}`, () => assert.strictEqual(v.isYouTube(val), false)));
  });
});
