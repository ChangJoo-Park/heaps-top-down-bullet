import h2d.col.Point;
import haxe.io.Input;
import h3d.scene.fwd.Renderer.NormalPass;
import h2d.Graphics;
import hxd.Res;
import hxd.Key in Key;
import h2d.Interactive;

class Bullet {
	public var disposed:Bool = false;

	var startPoint:Point;
	var targetPoint:Point;
	var moveX:Float;
	var moveY:Float;
	var velocityX:Float;
	var velocityY:Float;
	var image:h2d.Graphics;

	public function new(s2d:h2d.Scene, startPoint:Point, targetPoint:Point, width:Float = 20.0, height:Float = 20.0, velocityX:Float = 0,
			velocityY:Float = 0) {
		this.startPoint = startPoint;
		this.targetPoint = targetPoint;
		this.velocityX = velocityX;
		this.velocityY = velocityY;

		disposed = false;
		image = new h2d.Graphics(s2d);
		image.beginFill(0xEA8220);
		image.drawRect(startPoint.x, startPoint.y, width, height);
		image.endFill();
	}

	public function update() {
		// if (disposable()) {
		// 	dispose();
		// 	return;
		// }
		image.x += velocityX;
		image.y += velocityY;
	}

	public function dispose() {
		image.remove();
		image = null;
		disposed = true;
	}

	private function disposable() {
		if (image != null) {
			return image.x > moveX / 2 && image.y > moveY / 2;
		} else {
			return true;
		}
	}
}

class BulletGroup {
	var bullets:Array<Bullet>;

	public function new() {
		bullets = new Array<Bullet>();
	}

	public function update() {
		for (bullet in bullets) {
			bullet.update();
		}
	}

	public function add(bullet:Bullet) {
		bullets.push(bullet);
	}

	public function remove(bullet:Bullet) {}
}

class Main extends hxd.App {
	var bulletGroup:BulletGroup;

	override function init() {
		// var logo:h2d.Tile = hxd.Res.logo.toTile();
		// var g:h2d.Graphics = new h2d.Graphics(s2d);

		// for (x in 0...4) {
		// 	for (y in 0...4) {
		// 		g.beginTileFill(x * logo.width, y * logo.height, 1, 1, logo);
		// 		g.drawRect(x * logo.width, y * logo.height, logo.width, logo.height);
		// 	}
		// }
		// g.endFill();
		var interactive = new h2d.Interactive(s2d.width, s2d.height, s2d);
		interactive.onClick = function(e:hxd.Event) {
			var target = new h2d.Graphics(s2d);
			target.beginFill(0xFFFFFF);
			target.drawRect(e.relX, e.relY, 10, 10);
			target.endFill();
			makeBullet(e.relX, e.relY);
		}
		var tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
		tf.text = "Hello World !";

		bulletGroup = new BulletGroup();
	}

	override function update(dt:Float) {
		handleKeyInput();
		bulletGroup.update();
	}

	function handleKeyInput() {
		var actionKey = Key.isPressed(Key.SPACE);

		// if (actionKey) {
		// 	makeBullet();
		// }
	}

	function makeBullet(targetX:Float, targetY:Float) {
		var angleRadians:Float = Math.atan2(targetY - (s2d.height / 2), targetX - (s2d.width / 2));
		var velocityX:Float = Math.cos(angleRadians) * 10.0;
		var velocityY:Float = Math.sin(angleRadians) * 10.0;
		var startPoint:Point = new Point(Std.int(s2d.width / 2), Std.int(s2d.height / 2));
		var targetPoint:Point = new Point(targetX, targetY);
		bulletGroup.add(new Bullet(s2d, startPoint, targetPoint, 20.0, 20.0, velocityX, velocityY));
	}

	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}
}
