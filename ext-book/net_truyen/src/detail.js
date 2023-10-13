async function detail(url) {
  const res = await Extension.request(url);

  const detailEl = await Extension.querySelector(res, "article.item-detail");
  const name = await Extension.querySelector(
    detailEl.content,
    "h1.title-detail"
  ).text;
  var cover = await Extension.getAttributeText(
    res,
    "div.detail-info img",
    "data-original"
  );
  if (cover == null) {
    cover = await Extension.getAttributeText(res, "div.detail-info img", "src");
  }
  if (cover && cover.startsWith("//")) {
    cover = "https:" + cover;
  }
  const authorRow = await Extension.querySelectorAll(
    detailEl.content,
    "li.author p"
  );
  const author = await Extension.querySelector(authorRow[1].content, "p").text;

  const description = await Extension.querySelector(
    detailEl.content,
    "div.detail-content p"
  ).text;
  return {
    name,
    cover,
    bookUrl: url,
    author,
    description,
  };
}
