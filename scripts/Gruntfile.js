"use strict";

var chalk = require('chalk');

module.exports = function (grunt) {
    grunt.loadNpmTasks('grunt-shell');
    grunt.loadNpmTasks('grunt-aglio');
    grunt.loadNpmTasks('grunt-dredd');
    grunt.loadNpmTasks('grunt-apimock');

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),

        /**
         * Import SQL file into DB
         *
         *  @args
         *      --file="string"
         *      --db="string"
         *      --username="string"
         *      --password="string"
         *
         *  @usage
         *      grunt import --file="/vagrant/my-box-config/sql/dump.sql" --db="mydb" --username="root" --password="root"
         */
        shell: {
            import: {
                command: function () {
                    return "mysql -u" + grunt.option('username') + " -p" + grunt.option('password') + " -e  'CREATE DATABASE IF NOT EXISTS " + grunt.option('db') + ";" + " use " + grunt.option('db') + "; source " + grunt.option('file') + ";'";
                },
                options: {
                    callback: log
                }
            }
        },
        /**
         * Concat Aglio
         */
        aglio: {
            your_target:{
              files:{
                "./api.html": ["./resources/users.md", "./resources/derp.md"]
              },
              options: {
                theme: "slate",
                separator: "\n"
              }
            }
          }
    });

    grunt.registerTask('import', ['shell:import']);
    grunt.registerTask('start:aglio', ['aglio']);

    grunt.registerTask('default', function () {
        grunt.log.write(chalk.cyan.bold('Hi I\'m the default task'));
    });
};

function log(err, stdout, stderr, cb) {
    if (stderr || err) {
        throw new Error(err, stderr);
    } else {
        console.log(chalk.green(stdout));
    }
    cb();
}
