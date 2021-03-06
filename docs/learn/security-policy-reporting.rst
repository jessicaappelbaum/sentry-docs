Security Policy Reporting
=========================

Sentry provides the ability to collect information on `Content-Security-Policy (CSP)
<https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy>`_ violations,
as well as `Expect-CT <https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Expect-CT>`_
and `HTTP Public Key Pinning (HPKP) <https://developer.mozilla.org/en-US/docs/Web/HTTP/Public_Key_Pinning>`_
failures by setting the proper HTTP header which results in violation/failure to be sent to
Sentry endpoint specified in `report-uri`.

The integration process consists of configuring the the appropriate header with
your project key's Security Header endpoint found at
**Project Settings > Security Headers**.

Content-Security-Policy
-----------------------

`Content Security Policy <https://en.wikipedia.org/wiki/Content_Security_Policy>`_ (CSP)
is a security standard which helps prevent cross-site scripting (XSS),
clickjacking and other code injection attacks resulting from execution of
malicious content in the trusted web page context.
It's enforced by browser vendors, and Sentry supports capturing CSP violations
using the standard reporting hooks.

To configure CSP reports in Sentry, you'll need to send a header from your server
describing your policy, as well specifying the authenticated Sentry endpoint::

    Content-Security-Policy: ...; report-uri https://sentry.io/api/<project>/security/?sentry_key=<key>

Alternatively you can setup CSP reports to simply send reports rather than
actually enforcing the policy::

    Content-Security-Policy-Report-Only: ...; report-uri https://sentry.io/api/<project>/security/?sentry_key=<key>

For more information, see the article on
`MDN <https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy>`__.

Expect-CT
---------

`Certificate Transparency <https://en.wikipedia.org/wiki/Certificate_Transparency>`_ (CT)
is a security standard which helps track and identify valid certificates,
allowing identification of maliciously issued certificates.

To configure reports in Sentry, you'll need to configure the Expect-CT a header
from your server::

    Expect-CT: ..., report-uri="https://sentry.io/api/<project>/security/?sentry_key=<key>"

For more information, see the article on `MDN <https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Expect-CT>`__.

HTTP Public Key Pinning
-----------------------

`HTTP Public Key Pinning <https://en.wikipedia.org/wiki/HTTP_Public_Key_Pinning>`_ (HPKP)
is a security feature that tells a web client to associate a specific cryptographic
public key with a certain web server to decrease the risk of MITM attacks with forged certificates.
It's enforced by browser vendors, and Sentry supports capturing violations using
the standard reporting hooks.

To configure HPKP reports in Sentry, you'll need to send a header from your server
describing your policy, as well specifying the authenticated Sentry endpoint::

    Public-Key-Pins: ...; report-uri="https://sentry.io/api/<project>/security/?sentry_key=<key>"

For more information, see the article on
`MDN <https://developer.mozilla.org/en-US/docs/Web/HTTP/Public_Key_Pinning>`__.

Additional Configuration
------------------------

In addition to the ``sentry_key`` parameter, you may also pass the following within the querystring for the report URI::

    sentry_environment:     The environment name (e.g. production).
    sentry_release:         The version of the application.
