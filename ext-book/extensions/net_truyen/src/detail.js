async function detail(bookUrl) {
  const res = await Extension.request(bookUrl);

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

  const totalChapters = (
    await Extension.querySelectorAll(res, "div.list-chapter ul a")
  ).length;

  let listGenre = [];
  const lstGenreEl = await Extension.querySelectorAll(
    detailEl.content,
    "li.kind.row p"
  );

  if (lstGenreEl.length == 2) {
    const lstElm = await Extension.querySelectorAll(lstGenreEl[1].content, "a");
    for (var el of lstElm) {
      listGenre.push({
        url: await Extension.getAttributeText(el.content, "a", "href"),
        title: await Extension.querySelector(el.content, "a").text,
      });
    }
  }

  return {
    name,
    cover,
    bookUrl,
    author,
    description,
    totalChapters,
    listGenre,
  };
}
