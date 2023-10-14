async function detail(bookUrl) {
  const res = await Extension.request(bookUrl);

  const detailBook = await Extension.querySelector(res, "div.book_detail")
    .outerHTML;

  const name = await Extension.querySelector(detailBook, "h1").text;

  var cover = await Extension.getAttributeText(
    detailBook,
    "div.book_avatar img",
    "src"
  );

  const authorRow = await Extension.querySelectorAll(detailBook, "li.author p");

  const statusRow = await Extension.querySelectorAll(detailBook, "li.status p");

  const author = await Extension.querySelector(authorRow[1].content, "p").text;

  const bookStatus = await Extension.querySelector(statusRow[1].content, "p")
    .text;

  const description = await Extension.querySelector(
    detailBook,
    "div.story-detail-info p"
  ).text;

  return {
    name,
    cover,
    bookUrl,
    bookStatus,
    author,
    description,
  };
}
