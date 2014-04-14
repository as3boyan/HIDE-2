module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    //uglify: {
      //options: {
        //banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
      //},
      //build: {
        //src: 'bin/core/<%= pkg.name %>.js',
        //dest: 'bin/core/<%= pkg.name %>.min.js'
      //}
    //}
	concat: 
	{
		options:
		{
			separator: ';',
		},
		
		js:
		{
			src: [
			'libs/js/jquery-2.0.3.min.js',
			'libs/js/bootstrap.min.js',
			'libs/js/jqxcore.js',
			'libs/js/*.js',
			'!libs/js/alertify.js',
			'libs/js/CodeMirror/lib/codemirror.js',
			'libs/js/CodeMirror/addon/search/searchcursor.js',
			'libs/js/CodeMirror/addon/search/search.js',
			'libs/js/CodeMirror/addon/dialog/dialog.js',
			'libs/js/CodeMirror/addon/comment/comment.js',
			'libs/js/CodeMirror/addon/lint/lint.js',
			'libs/js/CodeMirror/addon/wrap/hardwrap.js',
			'libs/js/CodeMirror/keymap/sublime.js',
			'libs/js/CodeMirror/addon/hint/show-hint.js',
			'libs/js/CodeMirror/addon/edit/matchbrackets.js',
			'libs/js/CodeMirror/addon/edit/closebrackets.js',
			'libs/js/CodeMirror/addon/fold/foldcode.js',
			'libs/js/CodeMirror/addon/fold/foldgutter.js',
			'libs/js/CodeMirror/addon/fold/brace-fold.js',
			'libs/js/CodeMirror/addon/fold/comment-fold.js',
			'libs/js/CodeMirror/addon/selection/active-line.js',
			'libs/js/CodeMirror/addon/search/match-highlighter.js',
			'libs/js/CodeMirror/mode/haxe/haxe.js',
			'libs/js/CodeMirror/mode/javascript/javascript.js',
			'libs/js/CodeMirror/mode/css/css.js',
			'libs/js/CodeMirror/mode/xml/xml.js',
			'libs/js/CodeMirror/mode/htmlmixed/htmlmixed.js',
			'libs/js/CodeMirror/mode/markdown/markdown.js',
			'libs/js/CodeMirror/mode/shell/shell.js',
			'libs/js/alertify.js/lib/alertify.min.js',
			],
			dest: 'bin/core/includes/js/main.js',
		},
	},
	uglify: 
	{
      options: {
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
      },
      build: {
        src: 'bin/core/includes/js/main.js',
        dest: 'bin/core/includes/js/main.min.js'
      }
    },
	cssmin: 
	{
		combine: 
		{
			files: 
			{
				'bin/core/includes/css/main.css': 
					[
					'libs/css/*',
					'libs/js/CodeMirror/lib/codemirror.css',
					'libs/js/CodeMirror/theme/*',
					'libs/js/CodeMirror/addon/fold/foldgutter.css',
					'libs/js/CodeMirror/addon/dialog/dialog.css',
					'libs/js/CodeMirror/addon/hint/show-hint.css',
					'libs/js/CodeMirror/addon/lint/lint.css',
					'libs/js/alertify.js/themes/alertify.core.css',
					'libs/js/alertify.js/themes/alertify.default.css',
					],
			}
		},
	},
	clean: ["bin/core/includes/js/main.js"]
  });

  //grunt.initConfig({
	  //nodewebkit: {
		//options: {
			//build_dir: './webkitbuilds', // Where the build version of my node-webkit app is saved
			//mac: true, // We want to build it for mac
			//win: true, // We want to build it for win
			//linux32: true, // We want to build it for linux32
			//linux64: true // We want to build it for linux64
		//},
		//src: ['bin/package.json']
		//src: ['./bin/**/*'] // Your node-webkit app
	  //},
	//});
  
  // Load the plugin that provides the "uglify" task.
  //grunt.loadNpmTasks('grunt-node-webkit-builder');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-cssmin');

  // Default task(s).
  grunt.registerTask('default', ['concat', 'uglify', 'cssmin', 'clean']);

};