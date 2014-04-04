module.exports = function(grunt) {

  // Project configuration.
  //grunt.initConfig({
    //pkg: grunt.file.readJSON('package.json'),
    //uglify: {
      //options: {
        //banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
      //},
      //build: {
        //src: 'bin/<%= pkg.name %>.js',
        //dest: 'build/<%= pkg.name %>.min.js'
      //}
    //}
  //});

  grunt.initConfig({
	  nodewebkit: {
		options: {
			build_dir: './webkitbuilds', // Where the build version of my node-webkit app is saved
			mac: true, // We want to build it for mac
			win: true, // We want to build it for win
			linux32: true, // We want to build it for linux32
			linux64: true // We want to build it for linux64
		},
		src: ['./bin/**/*'] // Your node-webkit app
	  },
	});
  
  // Load the plugin that provides the "uglify" task.
  //grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-node-webkit-builder');

  // Default task(s).
  grunt.registerTask('default', ['nodewebkit']);

};