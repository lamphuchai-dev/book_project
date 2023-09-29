// const puppeteer = require("puppeteer");

// (async () => {
//   // Khởi tạo trình duyệt
//   //   const browser = await puppeteer.launch({ headless: "new" });

//   var browser = Engine.newBrowser();
//   browser.setUserAgent(UserAgent.android());

//   browser.launchAsync(url + "/" + page);
//   browser.waitUrl(".*?api.truyen.onl/v2/books.*?", 10000);
//   browser.close();

//   var urls = JSON.parse(browser.urls());
//   var novelList = [];
//   var next = "";
//   urls.forEach((requestUrl) => {
//     if (requestUrl.indexOf("api.truyen.onl/v2/books") >= 0) {
//       let response = fetch(requestUrl, {
//         headers: {
//           "user-agent": UserAgent.android(),
//         },
//       }).json();
//       next = response._extra._pagination._next;
//       response._data.forEach((book) => {
//         novelList.push({
//           name: book.name,
//           link: "/truyen/" + book.slug,
//           description: book.author_name,
//           cover: book["poster"]["default"],
//           host: "https://metruyencv.com",
//         });
//       });
//     }
//   });
//   console.log(novelList);

//   //   // Mở một trang web mới
//   //   const page = await browser.newPage();

//   //   page.on("request", (request) => {
//   //     const { host, searchParams } = new URL(request.url());

//   //     if (request.method() == "GET" && host == "api.truyen.onl") {
//   //       console.log(`Yêu cầu: ${request.method()} ${request.url()}`);

//   //       console.log(searchParams.values.length > 2);
//   //     }
//   //   });

//   //   // Điều hướng đến một URL cụ thể
//   //   await page.goto("https://metruyencv.com/bang-xep-hang/thang/thinh-hanh");

//   //   // Chụp ảnh màn hình trang web và lưu thành tệp
//   //   //   await page.screenshot({ path: "example.png" });

//   //   // Đóng trình duyệt
//   //   //   await browser.close();
// })();

// fetch("https://jsonplaceholder.typicode.com/todos/1")
//   .then((response) => response.json())
//   .then((json) => {
//     sendMessage("log", JSON.stringify(json));
//   });
