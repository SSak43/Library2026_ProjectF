package Util; // パッケージ名はご自身の環境に合わせて変更してください

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class PasswordUtil {
	
	/**
	 * 入力された文字列をSHA-256でハッシュ化するメソッド
	 * @param plainPassword 画面から入力された生のパスワード
	 * @return 64文字のハッシュ化された文字列
	 */
	public static String hashSHA256(String plainPassword) {
		try {
			// SHA-256の変換器を準備
			MessageDigest md = MessageDigest.getInstance("SHA-256");
			// パスワードをバイト配列に変換してハッシュ計算
			byte[] hashBytes = md.digest(plainPassword.getBytes());
			
			// バイト配列を16進数の文字列（64文字）に変換する
			StringBuilder hexString = new StringBuilder();
			for (byte b : hashBytes) {
				String hex = Integer.toHexString(0xff & b);
				if (hex.length() == 1) {
					hexString.append('0'); // 1桁の場合は先頭に0を付ける
				}
				hexString.append(hex);
			}
			return hexString.toString();
			
		} catch (NoSuchAlgorithmException e) {
			// SHA-256が使えない環境の場合のエラー処理
			throw new RuntimeException("ハッシュ化アルゴリズムが見つかりません", e);
		}
	}
}