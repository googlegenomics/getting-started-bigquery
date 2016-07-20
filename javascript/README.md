# Getting started in javascript

| Deprecated |
|--------------------|
| This example is deprecated. The Google Genomics v1beta2 API is scheduled for turndown on August 15, 2016. When the API is turned down, this example will cease to function. |
| For an example of accessing the Google Genomics v1 API from Javascript, see the [Getting Started with the API](https://github.com/googlegenomics/getting-started-with-the-api/) repository. |

1. Javascript requires a client ID in addition to the Project ID you already set up:

    1. First select your [BigQuery enabled project](https://console.developers.google.com/project/_/apiui/credential)
     in the Google Developers Console.

    2. Once you are redirected to the **Credentials** tab, click **Create new Client ID** under
     the OAuth section.

    3. Set **Application type** to **Web application**, and change
     the **Authorized javascript origins** to `http://localhost:8000`

    4. Click the **Create Client ID** button

    5. From the newly created **Client ID for web application**, save the `Client ID`
     value.


2. Run a http server (this requires [python](https://www.python.org/download/)):
    ```
    cd getting-started-bigquery/javascript
    python -m SimpleHTTPServer 8000
    ```

3. Using the Client ID value that you made in step 1, view the code at:
   http://localhost:8000#your-client-id-goes-here
