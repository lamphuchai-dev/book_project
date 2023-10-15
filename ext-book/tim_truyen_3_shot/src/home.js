// https://timtruyen3shot.com/danh-sach-truyen.html?sort=last_update&sort_type=DESC

async function home(url, page) {
  const res = await Extension.request(url, {
    queryParameters: { page: page ?? 0 },
  });
  const list = await Extension.getElementsByClassName(res, "item item-spc");
  const result = [];
  return list;

  for (const item of list) {
    const html = item.content;
    var cover = await Extension.getAttributeText(html, "img", "data-original");
    if (cover == null) {
      cover = await Extension.getAttributeText(html, "img", "src");
    }
    if (cover && cover.startsWith("//")) {
      cover = "https:" + cover;
    }

    result.push({
      name: await Extension.querySelector(html, "h3 a").text,
      bookUrl: await Extension.getAttributeText(html, "h3 a", "href"),
      description: await Extension.querySelector(html, ".comic-item li a").text,
      cover,
    });
  }
  return result;
}

runFn(() =>
  home(
    "https://timtruyen3shot.com/danh-sach-truyen.html?sort=last_update&sort_type=DESC"
  )
);
