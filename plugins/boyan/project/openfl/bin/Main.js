(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		NewProjectDialog.getCategory("OpenFL").addItem("OpenFL Project",null,false);
		NewProjectDialog.getCategory("OpenFL").addItem("OpenFL Extension",null,false);
		NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("ActuateExample",null,false,true);
		NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("AddingAnimation",null,false,true);
		NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("AddingText",null,false,true);
		NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("DisplayingABitmap",null,false,true);
		NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("HandlingKeyboardEvents",null,false,true);
		NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("HandlingMouseEvent",null,false,true);
		NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("HerokuShaders",null,false,true);
		NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("PiratePig",null,false,true);
		NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("PlayingSound",null,false,true);
		NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("SimpleBox2D",null,false,true);
		NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("SimpleOpenGLView",null,false,true);
	});
	HIDE.notifyLoadingComplete(Main.$name);
};
Main.$name = "boyan.project.openfl";
Main.dependencies = ["boyan.bootstrap.new-project-dialog"];
Main.main();
})();

//# sourceMappingURL=Main.js.map