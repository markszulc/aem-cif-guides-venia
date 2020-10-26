<%@ page import="org.apache.sling.api.resource.ValueMap"
         session="false"
%><%@include file="/libs/granite/ui/global.jsp"%><%

    ValueMap props = resource.getValueMap();
    // TODO XSS endpoint
    String endpoint = request.getContextPath() + props.get("endpoint", "/bin/cqgraphql");

%>
<!--
 *  Copyright (c) 2019 GraphQL Contributors
 *  All rights reserved.
 *
 *  This source code is licensed under the license found in the
 *  LICENSE file in the root directory of this source tree.
-->
<!DOCTYPE html>
<html>
  <head>
    <style>
      body {
        height: 100%;
        margin: 0;
        width: 100%;
        overflow: hidden;
      }

      #graphiql {
        height: 100vh;
      }
    </style>

    <!--
      This GraphiQL example depends on Promise and fetch, which are available in
      modern browsers, but can be "polyfilled" for older browsers.
      GraphiQL itself depends on React DOM.
      If you do not want to rely on a CDN, you can host these files locally or
      include them directly in your favored resource bunder.
    -->
    <script
      crossorigin
      src="https://unpkg.com/react@16/umd/react.development.js"
    ></script>
    <script
      crossorigin
      src="https://unpkg.com/react-dom@16/umd/react-dom.development.js"
    ></script>

    <!--
      These two files can be found in the npm module, however you may wish to
      copy them directly into your environment, or perhaps include them in your
      favored resource bundler.
     -->
    <link rel="stylesheet" href="https://unpkg.com/graphiql/graphiql.min.css" />
    <ui:includeClientLib categories="granite.utils" />
  </head>

  <body>
    <div id="graphiql">Loading...</div>
    <script
      src="https://unpkg.com/graphiql/graphiql.min.js"
      type="application/javascript"
    ></script>
    <script>
      function graphQLFetcher(graphQLParams) {
        return fetch(
          '<%= endpoint %>',
          {
            method: 'post',
            headers: {
              Accept: 'application/json',
              'Content-Type': 'application/json',
            },
            body: JSON.stringify(graphQLParams),
            credentials: 'include',
          },
        ).then(function (response) {
          return response.json().catch(function () {
            return response.text();
          });
        });
      }

      if (Granite.Toggles.isEnabled("ft-cq-4296639")) {
          ReactDOM.render(
              React.createElement(GraphiQL, {
                  fetcher: graphQLFetcher,
                  defaultVariableEditorOpen: true,
              }),
              document.getElementById('graphiql'),
          );
      } else {
          document.getElementById('graphiql').innerHTML = "GraphQL feature is disabled.";
      }
    </script>
  </body>
</html>