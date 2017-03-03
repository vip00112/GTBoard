package com.gt.board.util;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;

/** 각종 설정을 위한 XML Mashal, Unmarshal **/
public class XMLUtil {
    private static final Logger logger = LoggerFactory.getLogger(XMLUtil.class);

    private DocumentBuilder builder;
    private Transformer transformer;

    public XMLUtil() {
        try {
            builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
            transformer = TransformerFactory.newInstance().newTransformer();
            transformer.setOutputProperty(OutputKeys.INDENT, "yes");
            transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4");
        } catch (Exception e) {
            logger.warn("XMLUtil 생성 실패.", e);
        }
    }

    /** java 객체를 Node로 변환 후 xml 파일로 생성
     *  @param c java class
     *  @param obj 변환할 객체
     *  @param filePath 생성될 xml 파일의 경로 **/
    public void setMarshalObject(Class<?> c, Object obj, String filePath) {
        try {
            JAXBContext context = JAXBContext.newInstance(c);
            Marshaller m = context.createMarshaller();
            m.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE);
            m.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
            Document doc = builder.newDocument();
            m.marshal(obj, doc);

            DOMSource source = new DOMSource(doc);
            StreamResult result = new StreamResult(filePath);
            transformer.transform(source, result);
        } catch (Exception e) {
            logger.warn(filePath + "의 생성에 실패.", e);
        }
    }

    /** xml 파일을 파싱하여 java 객체로 반환
     *  @param c java class
     *  @param filePath 읽어올 xml 파일의 경로 **/
    public Object getUnmarshalObject(Class<?> c, String filePath) {
        try {
            JAXBContext context = JAXBContext.newInstance(c);
            Unmarshaller um = context.createUnmarshaller();
            Document doc = builder.parse(filePath);
            return um.unmarshal(doc);
        } catch (Exception e) {
            logger.warn(filePath + "의 로드에 실패.", e);
        }
        return null;
    }
}
