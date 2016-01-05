/**
 * Make a X-Domain request to url and callback.
 *
 * @param url {String}
 * @param method {String} HTTP verb ('GET', 'POST', 'DELETE', etc.)
 * @param data {String} request body
 * @param callback {Function} to callback on completion
 * @param errback {Function} to callback on error
 */
function xdr(url, method, data, callback, errback) {
    var req;

    console.log("Sending request to "+url);
    
    if(XMLHttpRequest) {
        console.log("Sending request as XMLHttpRequest");
        req = new XMLHttpRequest();
        //req.setRequestHeader('Accept', 'application/json');
        //req.responseType = "json";

        if('withCredentials' in req) {
            try
            {
                console.log("With Credentials "+method+" "+url);
                req.open(method, url, true);
                console.log("With Credentials 2");
                req.onerror = errback;
                console.log("With Credentials 2");
                req.onreadystatechange = function() {
                    console.log("CALL BACK FROM REQUEST");
                    if (req.readyState === 4) {
                        if (req.status >= 200 && req.status < 400) {
                            console.log("Good Response");
                            callback(req.responseText);
                        } else {
                            console.log("Error Response"+req.status);
                            errback(new Error('Response returned with non-OK status'));
                        }
                    }
                };
                console.log("About to send request");
                req.send(data);
            }
            catch (err)
            {
                console.log("Exception "+err);
            }
            console.log("Request Sent");
        }
    } else if(XDomainRequest) {
        console.log("Sending request as XDomainRequest");
        req = new XDomainRequest();
        req.open(method, url);
        req.onerror = errback;
        req.onload = function() {
            callback(req.responseText);
        };
        req.send(data);
    } else {
        console.log("Can not send request");
        errback(new Error('CORS not supported'));
    }
}