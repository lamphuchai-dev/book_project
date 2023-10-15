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

  directories.forEach((extFolder) => {
    const pathFolderExt = `${extFolder.path}/${extFolder.name}`;
    const files = fs.readdirSync(pathFolderExt);
    const zip = new AdmZip();
    files.forEach((file) => {
      const filePath = `${pathFolderExt}/${file}`;

      if (fs.lstatSync(filePath).isDirectory()) {
        zip.addLocalFolder(filePath, file);
      } else {
        zip.addLocalFile(filePath);
      }
    });
    zip.writeZip(`${pathFolderExt}/extension.zip`);
  });
} catch (err) {
  console.error("Lỗi khi đọc thư mục:", err);
}
