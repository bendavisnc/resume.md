const puppeteer = require('puppeteer');
const path = require('path');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  await page.goto(`file:${path.join(__dirname, 'out/resume.html')}`, { waitUntil: 'networkidle2' });
  await page.pdf({ path: 'out/resume.pdf' });
  await browser.close();
})();


