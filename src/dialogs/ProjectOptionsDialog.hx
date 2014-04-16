package dialogs;
import bootstrap.ButtonManager;
import projectaccess.ProjectOptions;

/**
 * ...
 * @author AS3Boyan
 */
class ProjectOptionsDialog extends ModalDialog
{

	public function new() 
	{
		super("Project Options");
		
		getBody().appendChild(ProjectOptions.page);
		getFooter().appendChild(ButtonManager.createButton("OK", false, true, true));
	}
	
}