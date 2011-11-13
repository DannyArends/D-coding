package example.jni;

public class InvocationHelloWorld {
	public static void main(String[] args) {
		System.out.println("Hello, World!");
		System.out.println("Arguments sent to this program:");
		if (args.length == 0) {
			System.out.println("(None)");
		} else {
			for (int i=0; i<args.length; i++) {
				System.out.print(args[i] + " ");
			}
			System.out.println();
		}
	}
}
