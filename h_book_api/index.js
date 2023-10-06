const puppeteer = require("puppeteer");
const Ext = require("./src/ext");

class BaseExt extends Ext {}
(async () => {
  // Khởi tạo trình duyệt
  // const browser = await puppeteer.launch({ headless: false });

  // const page = await browser.newPage();
  // page.setUserAgent(
  //   "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1"
  // );
  // await page.setRequestInterception(true);
  // page.on("request", (request) => {
  //   const { host, searchParams } = new URL(request.url());

  //   if (request.method() == "GET" && host == "api.truyen.onl") {
  //     console.log(`Yêu cầu: ${request.method()} ${request.url()}`);
  //   }
  //   request.continue();
  // });

  // // Điều hướng đến một URL cụ thể
  // await page.goto("https://metruyencv.com/bang-xep-hang/thang/thinh-hanh");

  // await page.setCookie({
  //   name: "l_token",
  //   value:
  //     "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9hcGkudHJ1eWVuLm9ubFwvdjJcL2F1dGhcL3JlZnJlc2giLCJpYXQiOjE2OTU0NzczOTcsImV4cCI6MTY5NjQzNTEwNCwibmJmIjoxNjk2MDAzMTA0LCJqdGkiOiJNdkJUWXdvM1NKdmg1aXpNIiwic3ViIjoxMzA0ODQ1fQ.raVZtz0Wqn9_Q5pLWnULVmQ-rYH6Snwbuq63WuvKKkY",
  // });

  // // Chụp ảnh màn hình trang web và lưu thành tệp
  // await page.screenshot({ path: "example.png" });

  // console.log(await page.cookies());

  // const tmp = page.queryObjects

  // Đóng trình duyệt
  // await browser.close();

  var tmp = new BaseExt();
  console.log(tmp.host);

  var doc = document.querySelector(".comic-item li a");
  console.log(doc);
})();

