String mainJs = '''
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
  static async request(url, options) {
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
  static querySelector(content, selector) {
    return new Element(content, selector);
  }
  static queryXPath(content, selector) {
    return new XPathNode(content, selector);
  }
  static async querySelectorAll(content, selector) {
    let elements = [];
    JSON.parse(
      await sendMessage("querySelectorAll", JSON.stringify([content, selector]))
    ).forEach((e) => {
      elements.push(new Element(e, selector));
    });
    return elements;
  }
  static async getAttributeText(content, selector, attr) {
    return await sendMessage(
      "getAttributeText",
      JSON.stringify([content, selector, attr])
    );
  }
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

String itemHome = '''
async function getListBook(url, page) {
  const res = await Extension.request(url, {
    queryParameters: {
      page: page ?? 0,
    },
  });
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
  }
  return result;
}

''';

String itemHomeTest = '''
async function itemHome(url, page) {
    const res = await Extension.request(url, {
      queryParameters: { page: page ?? 0 },
    });
    const list = await Extension.querySelectorAll(res, "div.items div.item");
    const result = [];

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

''';

String detail = '''
  async function detail(url) {
    const res = await Extension.request(url);
    const detailEl = await Extension.querySelector(res, "div.site-content");
    const name = await Extension.querySelector(detailEl.content, "div.post-title h1")
      .text;

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
  console.log(name);

    return {
      name,
      cover,
      bookUrl: url,
      author,
      description,
    };
  }

''';
