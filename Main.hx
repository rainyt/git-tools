import sys.io.Process;
import sys.FileSystem;

/**
 * 这是一个简易的批量提交资源的实现，例如有很多大量的资源，超过100MB以上需要分批提交时，会很容易发生与服务器中断导致无法提交资源时进行使用。
 */
class Main {
	/**
	 * 提交大小
	 */
	public static var size:Float = 0;

	/**
	 * 每多少MB提交一次文件
	 */
	public static var maxsize:Float = 1024 * 1024 * 10;

	/**
	 * 预备提交
	 */
	public static var files:Array<String> = [];

	static function main() {
		var args = Sys.args();
		trace(args);
		var action = args[0];
		var project = args[1];
		Sys.setCwd(project);
		switch (action) {
			case "commit":
				// 分批提交处理
				commitGitStatus();
		}
	}

	static function commitGitStatus():Void {
		Sys.command("git reset");
		var proess = new Process("git status");
		var content = proess.stdout.readAll().toString();
		var start = "Untracked";
		content = content.substr(content.indexOf(start) + start.length);
		var files = content.split("\n");
		trace("准备上传文件数量：", files.length);
		for (file in files) {
			file = StringTools.replace(file, "\t", "");
			if (FileSystem.exists(file)) {
				commitFile(file);
			}
		}
		if (files.length > 0) {
			commitToGit();
		}
	}

	static function commitToGit():Void {
		trace('ready upload ${Std.int(size / 1024) + "MB"}');
		Sys.command('git commit -m "${"分批提交" + files.length + "个文件"}"');
		Sys.command("git push origin main --force");
		files = [];
		size = 0;
	}

	static function commitFile(path:String):Void {
		trace("Git commit:" + path);
		if (FileSystem.isDirectory(path)) {
			var files = FileSystem.readDirectory(path);
			for (file in files) {
				commitFile(path + "/" + file);
			}
		} else {
			// 尝试提交：
			var stat = FileSystem.stat(path);
			size += stat.size;
			// 单个文件添加
			Sys.command("git add " + path);
			files.push(path);
			// 当超过某个大小后，一次提交
			if (size > maxsize) {
				commitToGit();
			}
		}
	}
}
