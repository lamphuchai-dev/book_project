export default class extends Extension {
  async itemHome(url, page) {
    const res = await this.request(this.hostExt + url, {
      queryParameters: { page: page ?? 0 },
    });
    const list = await this.querySelectorAll(res, "div.items div.item");
    const result = [];

    for (const item of list) {
      const html = item.content;
      var cover = await this.getAttributeText(html, "img", "data-original");
      if (cover == null) {
        cover = await this.getAttributeText(html, "img", "src");
      }
      if (cover && cover.startsWith("//")) {
        cover = "https:" + cover;
      }

      result.push({
        name: await this.querySelector(html, "h3 a").text,
        bookUrl: await this.getAttributeText(html, "h3 a", "href"),
        description: await this.querySelector(html, ".comic-item li a").text,
        host: this.hostExt,
        cover,
      });
    }
    return result;
  }

  async detail(url) {
    const res = await this.request(url);

    const detailEl = await this.querySelector(res, "article.item-detail");
    const name = await this.querySelector(detailEl.content, "h1.title-detail")
      .text;
    var cover = await this.getAttributeText(
      res,
      "div.detail-info img",
      "data-original"
    );
    if (cover == null) {
      cover = await this.getAttributeText(res, "div.detail-info img", "src");
    }
    if (cover && cover.startsWith("//")) {
      cover = "https:" + cover;
    }
    const authorRow = await this.querySelectorAll(
      detailEl.content,
      "li.author p"
    );
    const author = await this.querySelector(authorRow[1].content, "p").text;

    const description = await this.querySelector(
      detailEl.content,
      "div.detail-content p"
    ).text;
    return {
      name,
      cover,
      bookUrl: url,
      author,
      description,
      host: this.hostExt,
    };
  }

  async chapters(bookUrl, html) {
    if (html == null) {
      html = await this.request(bookUrl);
    }

    const listEl = await this.querySelectorAll(html, "div.list-chapter ul a");
    const chapters = [];

    for (var index = 0; index < listEl.length; index++) {
      const el = listEl[index].content;
      const url = await this.getAttributeText(el, "a", "href");
      const title = await this.querySelector(el, "a").text;
      chapters.push({
        title,
        url,
        bookUrl,
        index: listEl.length - index,
      });
    }
    return chapters;
  }

  async chapter(url) {
    const res = await this.request(url);
    const listEl = await this.querySelectorAll(res, "div.page-chapter img");
    let result = [];
    for (const element of listEl) {
      var image = await this.getAttributeText(element.content, "img", "src");
      if (image == null) {
        image = await this.getAttributeText(
          element.content,
          "img",
          "data-original"
        );
      }
      if (image && image.startsWith("//")) {
        image = "https:" + image;
      }
      result.push(image);
    }
    return result;
  }

  async search(kw, page, filter) {
    const res = await this.request(this.hostExt + "/tim-truyen", {
      queryParameters: { page: page, keyword: kw },
    });

    const list = await this.querySelectorAll(res, "div.items div.item");
    const result = [];
    for (const item of list) {
      var html = item.content;
      var cover = await this.getAttributeText(html, "img", "src");
      if (cover && cover.startsWith("//")) {
        cover = "https:" + cover;
      }
      result.push({
        name: await this.querySelector(html, "h3 a").text,
        bookUrl: await this.getAttributeText(html, "h3 a", "href"),
        description: await this.querySelector(html, ".comic-item li a").text,
        host: this.hostExt,
        cover,
      });
    }
    return result;
  }
}
