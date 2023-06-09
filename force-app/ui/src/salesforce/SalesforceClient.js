import LCC from "lightning-container";
import axios from "axios";
export default class salesforceClient {
  constructor() {}

  async call(endpoint, payload) {
    if (!endpoint.includes(".")) {
      throw "Invalid endpoint given: no period character found. Desired structure: controller.method";
    }

    if (!(payload instanceof Object)) {
      throw "Payload must be an instance of Object";
    }

    payload = JSON.stringify(payload) || "{}";

    if (import.meta.env.DEV) {
      return await this._callRestApi(endpoint, payload);
    }

    return await this._callAuraContainer(endpoint, payload);
  }

  async navigate(uri) {
    let prefix = "";

    try {
      if (import.meta.env.DEV && import.meta.env.SF_INSTANCE_URL) {
        prefix = import.meta.env.SF_INSTANCE_URL;
      }
    } catch (e) {
      console.error(e);
    }

    window.open(`${prefix}/${uri}`, "_blank");
  }

  /**
   * apexCallConfiguration docs: https://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/pages_js_remoting_configuring_request.htm?q=remoting%20timeout
   * @param endpoint
   * @param payload
   * @returns {Promise<unknown>}
   * @private
   */
  _callAuraContainer(endpoint, payload) {
    return new Promise((resolve, reject) => {
      LCC.callApex(
        "WebApiVFEntryPoint.handle",
        { endpoint: endpoint, body: payload },
        (result, event) => {
          if (200 <= event.statusCode && 300 > event.statusCode) {
            resolve(JSON.parse(result.body));
            return;
          }
          reject(event.message);
        },
        { escape: false }
      );
    });
  }

  async _callRestApi(endpoint, payload) {
    try {
      if (!import.meta.env.DEV) {
        return;
      }
      const response = await axios.post(`/sfRestProxy`, {
        endpoint: endpoint,
        body: payload
      });

      return JSON.parse(response.data.body);
    } catch (e) {
      console.error("Dev Rest Exception", e.message);
    }
  }
}
