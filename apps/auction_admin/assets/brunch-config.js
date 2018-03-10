exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: {
        "js/app.js": /^(js)|(node_modules)/,
        "js/ex_admin_common.js": ["vendor/ex_admin_common.js"],
        "js/admin_lte2.js": ["vendor/admin_lte2.js"],
        "js/jquery.min.js": ["vendor/jquery.min.js"],
      }
    },
    stylesheets: {
      joinTo: {
        "css/app.css": /^(css)/,
        "css/admin_lte2.css": ["vendor/admin_lte2.css"],
        "css/active_admin.css.css": ["vendor/active_admin.css.css"],
      },
      order: {
        after: ["css/app.css"] // concat app.css last
      }
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/assets/static". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(static)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: ["static", "css", "js", "vendor"],
    // Where to compile files to
    public: "../priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/vendor/]
    },
    sass: {
      options: {
        includePaths: ["node_modules/simditor/styles"]
      }
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["js/app"]
    }
  },

  npm: {
    enabled: true,
    globals: {
      Simditor: "simditor"
    }
  }
};

// To add the ExAdmin generated assets to your brunch build, do the following:
//
// Replace
//
//     javascripts: {
//       joinTo: "js/app.js"
//     },
//
// With
//
//     javascripts: {
//       joinTo: {
//         "js/app.js": /^(js)|(node_modules)/,
//         "js/ex_admin_common.js": ["vendor/ex_admin_common.js"],
//         "js/admin_lte2.js": ["vendor/admin_lte2.js"],
//         "js/jquery.min.js": ["vendor/jquery.min.js"],
//       }
//     },
//
// Replace
//
//     stylesheets: {
//       joinTo: "css/app.css",
//       order: {
//         after: ["css/app.css"] // concat app.css last
//       }
//     },
//
// With
//
//     stylesheets: {
//       joinTo: {
//         "css/app.css": /^(css)/,
//         "css/admin_lte2.css": ["vendor/admin_lte2.css"],
//         "css/active_admin.css.css": ["vendor/active_admin.css.css"],
//       },
//       order: {
//         after: ["css/app.css"] // concat app.css last
//       }
//     },
//

// To add the ExAdmin generated assets to your brunch build, do the following:
//
// Replace
//
//     javascripts: {
//       joinTo: "js/app.js"
//     },
//
// With
//
//     javascripts: {
//       joinTo: {
//         "js/app.js": /^(js)|(node_modules)/,
//         "js/ex_admin_common.js": ["vendor/ex_admin_common.js"],
//         "js/admin_lte2.js": ["vendor/admin_lte2.js"],
//         "js/jquery.min.js": ["vendor/jquery.min.js"],
//       }
//     },
//
// Replace
//
//     stylesheets: {
//       joinTo: "css/app.css",
//       order: {
//         after: ["css/app.css"] // concat app.css last
//       }
//     },
//
// With
//
//     stylesheets: {
//       joinTo: {
//         "css/app.css": /^(css)/,
//         "css/admin_lte2.css": ["vendor/admin_lte2.css"],
//         "css/active_admin.css.css": ["vendor/active_admin.css.css"],
//       },
//       order: {
//         after: ["css/app.css"] // concat app.css last
//       }
//     },
//
