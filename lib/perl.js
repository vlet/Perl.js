var console = {
    log: function(message) {
        print(message)
    }
},
process = {
    platform: "perljs",
    version: "0.1"
};

perljs.fn.isEmpty = function(o) {
    for (var i in o) {
        return false;
    }
    return true;
};

perljs.c = {};

perljs.coremodules = {
    fs: {
        readFileSync: function(filename) {
            var file = perljs.fn.loadfile(filename);
            if (file.error) {
                throw new Error(file.error);
            }
            return file.content;
        }
    },
    path: {
        dirname: function() {
            return __dirname;
        }
    },
    url: {
        parse: function() {
            return ''
        }
    },
    http: {
        dumb: function() {
            return ''
        }
    },
    https: {
        dumb: function() {
            return ''
        }
    },
    request: {
        dumb: function() {
            return ''
        }
    },
    cssom: {
        dumb: function() {
            return ''
        }
    },
    assert: {
        equal: function(a, b) {
            return a == b
        }
    },
    vm: {
        runInContext: function(code, context) {
            return eval(code);
        }
    }
};

var __require = function(perljs_dir, perljs_name) {
    var exports = {},
    module = {
        exports: {}
    },
    __dirname = (perljs_dir + perljs_name).match(/^.+\//)[0],
    __filename = perljs_dir + perljs_name,
    require = function(name) {
        return __require(__dirname, name);
    };

    if (!/\//.test(perljs_name)) {
        if (perljs.coremodules.hasOwnProperty(perljs_name)) {
            return perljs.coremodules[perljs_name];
        }
        else {
            throw new Error("module " + perljs_name + " not implemented");
        }
    }
    var perljs_file = perljs.fn.loadfile(perljs_dir + perljs_name + ".js");

    if (perljs_file.error) {
        throw new Error(perljs_file.error);
    }

    if (perljs.c.hasOwnProperty(perljs_file.path)) {
        return perljs.c[perljs_file.path];
    }

    perljs.c[perljs_file.path] = {};
    eval(perljs_file.content);

    if (!perljs.fn.isEmpty(exports)) {
        perljs.c[perljs_file.path] = exports;
    }
    else if (!perljs.fn.isEmpty(module.exports)) {
        perljs.c[perljs_file.path] = module.exports;
    }
    return perljs.c[perljs_file.path];
};

var __dirname = '';
var __filename = __dirname + "/perl.js";

var require = function(name) {
    return __require(__dirname , name);
};
