const glob = require("glob");
const fs = require("fs");
const AdmZip = require("adm-zip");
const path = require("path");

// const data = {
//   metadata: {
//     author: "Đạt Bi",
//     description: "📛🔻📛",
//   },
//   data: [],
// };

// var files = glob.sync("*/*.json");
// files.forEach((file)=>{
//     console.log(file)
// })

const extensionsPath = "./extensions"; // Đường dẫn đến thư mục

try {
  const directories = fs
    .readdirSync(extensionsPath, { withFileTypes: true })
    .filter((item) => item.isDirectory());
  const zip = new AdmZip();
  directories.forEach((extFolder) => {
    const extPath = extFolder.path + "/" + extFolder.name + "/";
    console.log(extPath);
    const zipPath = extPath + "/extension.zip";
    // Đọc nội dung của thư mục và thêm vào tệp zip
    zip.addLocalFolder(extPath, path.basename(extPath));
    // Lưu tệp zip
    zip.writeZip(zipPath);
  });
} catch (err) {
  console.error("Lỗi khi đọc thư mục:", err);
}
