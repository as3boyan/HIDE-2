package ;
import js.Browser;
import js.html.DivElement;
import js.html.Element;
import js.three.*;

/**
 * ...
 * @author AS3Boyan
 */
class Presentation
{
    static var mesh:Mesh;
    static var renderer:CanvasRenderer;
    static var scene:Scene;
    static var camera:PerspectiveCamera;

	public static function main()
	{	
        var geometry, material;

        var init = function () {

            renderer = new CanvasRenderer();
            renderer.setSize( Browser.window.innerWidth, Browser.window.innerHeight );
            Browser.document.body.appendChild( renderer.domElement );

            camera = new PerspectiveCamera( 75, Browser.window.innerWidth / Browser.window.innerHeight, 1, 1000 );
            camera.position.z = 500;

            scene = new Scene();

            geometry = new CubeGeometry( 200, 200, 200 );
            material = new MeshBasicMaterial( { color: 0x000000, wireframe: true, wireframeLinewidth: 2 } );

            mesh = new Mesh( geometry, material );
            scene.add( mesh );

        }

        init();
        animate(null);
	}

    public static function animate(e)
    {
        js.three.Three.requestAnimationFrame( animate );

        mesh.rotation.x = Date.now().getTime() * 0.0005;
        mesh.rotation.y = Date.now().getTime() * 0.001;

        renderer.render( scene, camera );

        return true;
    }
}