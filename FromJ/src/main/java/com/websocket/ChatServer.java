package com.websocket;

import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

/*
WebSocket 서버 엔드포인트였음. 주소는 ws://서버주소/ChatingServer.

하는 일:

@OnOpen에서 새로 연결된 세션을 Set에 등록했음.

@OnMessage에서 받은 메시지를 다른 모든 세션에 브로드캐스트했음(보낸 본인 제외).

@OnClose에서 끊긴 세션 제거했음.

@OnError에서 에러 로그 찍었음.

세션 목록은 static synchronizedSet으로 관리해서 동시성을 신경 썼음.
*/


/**
 * WebSocket 서버 엔드포인트
 * 클라이언트는 ws://<호스트[:포트]>/ChatingServer 로 접속함
 */
@ServerEndpoint("/ChatingServer")
public class ChatServer {

	/**
	 * 접속 중인 모든 클라이언트 세션을 보관하는 Set
	 * - 다중 스레드 환경이므로 synchronizedSet 사용함
	 * - static으로 서버 인스턴스 간 공유함(엔드포인트는 요청마다 인스턴스 생성될 수 있음)
	 */
	private static Set<Session> clients = Collections.synchronizedSet(new HashSet<Session>());

	/**
	 * 클라이언트가 최초 연결됐을 때 호출됨
	 * @param session 신규로 연결된 클라이언트 세션
	 */
	@OnOpen
	public void onOpen(Session session) {
		clients.add(session); // 세션 등록
		System.out.println("웹 소켓 연결 : " + session.getId());
	}

	/**
	 * 클라이언트로부터 텍스트 메시지를 수신했을 때 호출됨
	 * 현재 구현은 '브로드캐스트(보낸 사람 제외)'로 전달함
	 * @param message 수신한 메시지(예: "닉네임|내용")
	 * @param session 보낸 클라이언트 세션
	 */
	@OnMessage
	public void onMessage(String message, Session session) throws IOException {
		System.out.println("메시지 전송 : " + session.getId() + " : " + message);

		// 동시성 보호: clients 컬렉션 사용 시 전체 블록을 동기화함
		synchronized (clients) {
			for (Session client : clients) { // 연결된 모든 세션 순회
				if (!client.equals(session)) { // 보낸 당사자는 제외(클라에서 로컬 에코 처리 가정)
					try {
						// 텍스트 메시지 전송
						client.getBasicRemote().sendText(message);
					} catch (IOException e) {
						// 전송 실패 시 로그 남기고 끊어진 세션 정리
						System.out.println("메시지 전송 실패: " + e.getMessage());
						clients.remove(client); // 주의: 순회 중 제거는 CME 위험(보완 포인트 참고)
					}
				}
			}
		}
	}

	/**
	 * 클라이언트 연결이 종료됐을 때 호출됨
	 * @param session 종료된 세션
	 */
	@OnClose
	public void onClose(Session session) {
		clients.remove(session); // 세션 제거
		System.out.println("웹 소켓 종료 : " + session.getId());
	}

	/**
	 * 통신 중 에러가 발생했을 때 호출됨
	 * @param e 발생한 예외
	 */
	@OnError
	public void onError(Throwable e) {
		System.out.println("에러 발생: " + e.getMessage());
		e.printStackTrace();
	}
}
