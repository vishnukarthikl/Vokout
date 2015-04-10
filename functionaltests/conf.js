// An example configuration file.
exports.config = {
    directConnect: true,

    // Capabilities to be passed to the webdriver instance.
    capabilities: {
        'browserName': 'firefox'
    },

    // Spec patterns are relative to the current working directly when
    // protractor is called.
    specs: ['*.js'],
    baseUrl: 'http://localhost:5000',
    rootElement: '.vorkoutjs',

    onPrepare: function () {
        browser.driver.manage().window().maximize();
    },

    // Options to be passed to Jasmine-node.
    jasmineNodeOpts: {
        showColors: true,
        defaultTimeoutInterval: 30000
    }
};

if (process.env.SNAP_CI) {
    exports.config.chromeDriver = '/usr/local/bin/chromedriver';
}