export default class extends Extension {
  async itemHome(url, page) {
    const res = await this.request(this.hostExt + url, {
      queryParameters: {
        page: page ?? 0,
      },
    });
    const list = await this.querySelectorAll(res, "div.page-item-detail");
    const result = [];
    for (const item of list) {
      const html = item.content;
      var cover = await this.getAttributeText(html, "img", "data-src");

      if (cover == null) {
        cover = await this.getAttributeText(html, "img", "src");
      }
      if (cover && cover.startsWith("//")) {
        cover = "https:" + cover;
      }
      result.push({
        name: await this.querySelector(html, "div.post-title a").text,
        bookUrl: await this.getAttributeText(html, "div.post-title a", "href"),
        description: await await this.querySelector(html, "div.chapter-item a")
          .text,
        host: this.hostExt,
        cover,
      });
    }
    return result;
  }
  async detail(url) {
    const res = await this.request(url);

    const detailEl = await this.querySelector(res, "div.site-content");
    const name = await this.querySelector(detailEl.content, "div.post-title h1")
      .text;
    var cover = await this.getAttributeText(
      detailEl.content,
      "div.summary_image img",
      "src"
    );
    const authorRow = await this.querySelectorAll(
      detailEl.content,
      "div.post-content_item"
    );
    const author = await this.querySelector(
      authorRow[1].content,
      "div.summary-content"
    ).text;
    const description = await this.querySelector(
      detailEl.content,
      "div.description-summary p"
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
    const listEl = await this.querySelectorAll(
      res,
      "div.reading-content div.page-break"
    );
    let result = [];
    for (const element of listEl) {
      var image = await this.getAttributeText(element.content, "img", "src");
      if (image != null) {
        image = image.replace(/\n/g, "");
      }
      result.push(image);
    }
    return result;
  }
  async search(kw, page, filter) {
    const res = await this.request(this.hostExt + "/search", {
      queryParameters: {
        page: page,
        s: kw,
      },
    });
    const list = await this.querySelectorAll(res, "div.page-item-detail");
    const result = [];
    for (const item of list) {
      const html = item.content;
      var cover = await this.getAttributeText(html, "img", "data-src");
      if (cover == null) {
        cover = await this.getAttributeText(html, "img", "src");
      }
      if (cover && cover.startsWith("//")) {
        cover = "https:" + cover;
      }
      result.push({
        name: await this.querySelector(html, "div.post-title a").text,
        bookUrl: await this.getAttributeText(html, "div.post-title a", "href"),
        description: await await this.querySelector(html, "div.chapter-item a")
          .text,
        host: this.hostExt,
        cover,
      });
    }
    return result;
  }
}

async function detail(url) {
  const tmp = await fio();
  return tmp;
}

const tmp = await detail();

call(() => detail("fe"));

async function home(url, page) {
  const res = await Extension.request(url, {
    queryParameters: {
      page: page ?? 0,
    },
  });
  const list = await Extension.querySelectorAll(res, "div.page-item-detail");
  return list;
  const result = [];
  for (const item of list) {
    const html = item.content;
    var cover = await Extension.getAttributeText(html, "img", "data-src");

    if (cover == null) {
      cover = await Extension.getAttributeText(html, "img", "src");
    }
    if (cover && cover.startsWith("//")) {
      cover = "https:" + cover;
    }
    result.push({
      name: await Extension.querySelector(html, "div.post-title a").text,
      bookUrl: await Extension.getAttributeText(
        html,
        "div.post-title a",
        "href"
      ),
      description: await await Extension.querySelector(
        html,
        "div.chapter-item a"
      ).text,
      cover,
    });
    return result;
  }
}
run(() => home("https://saytruyenmoi.com/"));

async function home(url, page) {
  const res = await Extension.request(url, {
    queryParameters: {
      page: page ?? 0,
    },
  });
  // await Extension.querySelectorAll(html, "query")
  // await Extension.querySelector(html, "query")
  // await Extension.getAttributeText(html, "query","Attribute[src..]")

  const list = await Extension.querySelectorAll(res, "div.page-item-detail");
  const result = [];
  for (const item of list) {
    const html = item.content;
    var cover = await Extension.getAttributeText(html, "img", "data-src");

    if (cover == null) {
      cover = await Extension.getAttributeText(html, "img", "src");
    }
    if (cover && cover.startsWith("//")) {
      cover = "https:" + cover;
    }
    result.push({
      name: await Extension.querySelector(html, "div.post-title a").text,
      bookUrl: await Extension.getAttributeText(
        html,
        "div.post-title a",
        "href"
      ),
      description: await await Extension.querySelector(
        html,
        "div.chapter-item a"
      ).text,
      cover,
    });
    return result;
  }
}
runFn(() => home("https://saytruyenmoi.com/"));
