async function detail(url) {
  const res = await Extension.request(url);
  const detailEl = await Extension.querySelector(res, "div.site-content");
  const name = await Extension.querySelector(
    detailEl.content,
    "div.post-title h1"
  ).text;

  var cover = await Extension.getAttributeText(
    detailEl.content,
    "div.summary_image img",
    "src"
  );
  const authorRow = await Extension.querySelectorAll(
    detailEl.content,
    "div.post-content_item"
  );
  const author = await Extension.querySelector(
    authorRow[1].content,
    "div.summary-content"
  ).text;
  const description = await Extension.querySelector(
    detailEl.content,
    "div.description-summary p"
  ).text;

  return {
    name,
    cover,
    bookUrl: url,
    author,
    description,
  };
}
