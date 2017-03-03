# GTBoard
PHP 진영의 XE보드, 그누보드와 같이 일반 사용자도 쉽게 자신의 웹사이트 구축을 할 수 있도록 만든 java 기반의 보드

## 개발 환경
- Java 8
- Spring Framework 4.2.5
- Maven 3.3.9
- Tomcat 8
- MySQL 5.5

### DB 설정 방법
1. DB 폴더의 **gtboard.sql** 배치파일을 이용하여 배치
2. **webapp/META-INF/context.xml** 파일에서 `username`,`password`,`url` 설정

### 프로젝트/웹사이트 설정 문서(xml) 경로
- DB 접속
```
webapp/META-INF/context.xml
```
- MyBatis(typeAliases, Mappers)
```
webapp/WEB-INF/config/mybatis-config.xml
```
- Spring Root 설정
```
webapp/WEB-INF/config/root-context.xml
```
- Spring Dispatcher Servlet 설정
```
webapp/WEB-INF/config/servlet-context.xml
```
- 웹사이트 기본 설정(meta, footer 등)
```
webapp/WEB-INF/config/setting/setting-base.xml
(관리자 페이지 에서 실시간 수정 가능)
```
- 게시판 별 설정(meta, footer 등)
```
webapp/WEB-INF/config/setting/setting-board.xml
(관리자 페이지 에서 실시간 수정 가능)
```

### 특징
- 페이지별 CSS 파일이 /resources/css/skins 폴더에 개별적으로 작성되어 추후 커스터 마이징이 간편하다.
- 각종 설정이 xml 파일에 작성되어 있으므로 기존 웹사이트의 설정 백업이 용이하다.
- 관리자 페이지에서 웹사이트 설정, 게시판별 설정이 가능 하므로 비개발자의 사이트 운용이 간편하다.
- 포털사이트 검색 노출에 최적화된 meta 태그가 설정 되어 있다.
	- 기본 meta 태그 외 OpenGraph, Twitter용 meta 태그까지 포함

### 기타
- 기본적인 회원가입은 이메일 기반으로 인증 후 완료 됩니다.
	- Google SMTP를 이용하므로 Google 아이디 필수.
	- Spring Root 설정 xml에서 아이디/비밀번호 설정 해줘야 함.
``` xml
<!-- 이메일 관련 -->
<bean id="javaMailSender" class="org.springframework.mail.javamail.JavaMailSenderImpl">
<property name="host" value="smtp.gmail.com" />
<property name="port" value="587" />
<property name="username" value="아이디@gmail.com" />
<property name="password" value="비밀번호" />
<property name="javaMailProperties">
	<props>
		<prop key="mail.smtp.ssl.trust">smtp.gmail.com</prop>
		<prop key="mail.smtp.starttls.enable">true</prop>
		<prop key="mail.smtp.auth">true</prop>
	</props>
</property>
</bean>
```
- Googld SMTP는 하루 최대 메일 발송 제한이 있습니다.
	- 추후 Google/Naver/Facebook/Twitter 로그인 기능 구현 예정