const mainCode = '''
class Element {
  constructor(content, selector) {
    this.content = content;
    this.selector = selector || "";
  }

  async querySelector(selector) {
    return new Element(await this.excute(), selector);
  }

  async excute(fun) {
    return await sendMessage(
      "querySelector",
      JSON.stringify([this.content, this.selector, fun])
    );
  }

  async removeSelector(selector) {
    this.content = await sendMessage(
      "removeSelector",
      JSON.stringify([await this.outerHTML, selector])
    );
    return this;
  }

  async getAttributeText(attr) {
    return await sendMessage(
      "getAttributeText",
      JSON.stringify([await this.outerHTML, this.selector, attr])
    );
  }

  get text() {
    return this.excute("text");
  }

  get outerHTML() {
    return this.excute("outerHTML");
  }

  get innerHTML() {
    return this.excute("innerHTML");
  }
}
class XPathNode {
  constructor(content, selector) {
    this.content = content;
    this.selector = selector;
  }

  async excute(fun) {
    return await sendMessage(
      "queryXPath",
      JSON.stringify([this.content, this.selector, fun])
    );
  }

  get attr() {
    return this.excute("attr");
  }

  get attrs() {
    return this.excute("attrs");
  }

  get text() {
    return this.excute("text");
  }

  get allHTML() {
    return this.excute("allHTML");
  }

  get outerHTML() {
    return this.excute("outerHTML");
  }
}

class Extension {
  settingKeys = [];
  async request(url, options) {
    options = options || {};
    options.headers = options.headers || {};
    options.method = options.method || "get";
    const res = await sendMessage("request", JSON.stringify([url, options]));
    try {
      return JSON.parse(res);
    } catch (e) {
      return res;
    }
  }
  querySelector(content, selector) {
    return new Element(content, selector);
  }
  queryXPath(content, selector) {
    return new XPathNode(content, selector);
  }
  async querySelectorAll(content, selector) {
    let elements = [];
    JSON.parse(
      await sendMessage("querySelectorAll", JSON.stringify([content, selector]))
    ).forEach((e) => {
      elements.push(new Element(e, selector));
    });
    return elements;
  }
  async getAttributeText(content, selector, attr) {
    return await sendMessage(
      "getAttributeText",
      JSON.stringify([content, selector, attr])
    );
  }
  async home() {
    throw new Error("not implement home");
  }

  async itemHome() {
    throw new Error("not implement home");
  }

  search(kw, page, filter) {
    throw new Error("not implement search");
  }
  createFilter(filter) {
    throw new Error("not implement createFilter");
  }
  detail(url) {
    throw new Error("not implement detail");
  }
  chapter(url) {
    throw new Error("not implement chapter");
  }
  checkUpdate(url) {
    throw new Error("not implement checkUpdate");
  }
  async getSetting(key) {
    return sendMessage("getSetting", JSON.stringify([key]));
  }
  async registerSetting(settings) {
    console.log(JSON.stringify([settings]));
    this.settingKeys.push(settings.key);
    return sendMessage("registerSetting", JSON.stringify([settings]));
  }
  async load() {}


}

console.log = function (message) {
  if (typeof message === "object") {
    message = JSON.stringify(message);
  }
  sendMessage("log", JSON.stringify([message.toString()]));
};

async function stringify(callback) {
  const data = await callback();
  return typeof data === "object" ? JSON.stringify(data) : data;
}


''';

const netTruyen = '''
export default class extends Extension {
  async home() {

    return [
      {
        title: "Mới cập nhật",
        url: "/tim-truyen",
      },
      {
        title: "Truyện mới",
        url: "/tim-truyen?status=-1&sort=15",
      },
      {
        title: "Top all",
        url: "/tim-truyen?status=-1&sort=10",
      },
    ];
  }

  async itemHome(url, page) {
    const res = await this.request(url, { queryParameters: { page: page ?? 0 } });

    const list = await this.querySelectorAll(res, "div.items div.item");
    const result = [];
    for (const item of list) {
      const html = item.content;
      var cover = await this.getAttributeText(html, "img", "src");
      if (cover && cover.startsWith("//")) {
        cover = "https:" + cover;
      }
      result.push({
        name: await this.querySelector(html, "h3 a").text,
        link: await this.getAttributeText(html, "h3 a", "href"),
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

    var cover = await this.getAttributeText(detailEl.content, "img", "src");
    if (cover.startsWith("//")) {
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
      author,
      description,
      chapters: await this.chapters(res),
    };
  }

  async chapters(html) {
    const listEl = await this.querySelectorAll(html, "div.list-chapter ul a");
    const chapters = [];

    for (const element of listEl) {
      const url = await this.getAttributeText(element.content, "a", "href");
      const nameChapter = await this.querySelector(element.content, "a").text;
      chapters.push({
        url,
        nameChapter,
      });
    }
    return chapters;
  }

  async chapter(url) {
    const res = await this.request(url);
    const listEl = await this.querySelectorAll(res, "div.page-chapter img");
    let result = [];
    for (const element of listEl) {
      var img = await this.getAttributeText(element.content, "img", "src");
      var other = await this.getAttributeText(
        element.content,
        "img",
        "data-original"
      );
      if (img && img.startsWith("//")) {
        img = "https:" + img;
      }
      if (other && other.startsWith("//")) {
        other = "https:" + other;
      }
      result.push({ img, other });
    }

    return result;
  }

  async search(url, kw, page, filter) {
    const res = await this.request(url, {
      queryParameters: { page: page, keyword: kw },
    });

    const list = await this.querySelectorAll(res, "div.items div.item");
    const result = [];
    for (const item of list) {
      const html = item.content;
      const cover =  await this.getAttributeText(html, "img", "src");
      if (cover && cover.startsWith("//")) {
        cover = "https:" + cover;
      }
      result.push({
        name: await this.querySelector(html, "h3 a").text,
        link: await this.getAttributeText(html, "h3 a", "href"),
        cover,
      });
    }

  return   JSON.stringify(result);
      
    return result;
  }
}
''';
