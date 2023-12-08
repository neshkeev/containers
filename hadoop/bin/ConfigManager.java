package opt.configmanager;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import java.io.File;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class ConfigManager {

    public static Optional<Node> getValueNode(Document document, final String key) throws XPathExpressionException {
        XPathFactory xpathFactory = XPathFactory.newInstance();
        XPath xpath = xpathFactory.newXPath();
        String expression = MessageFormat.format("//name[text()=''{0}'']", key);

        return Optional.of(xpath.evaluate(expression, document, XPathConstants.NODESET))
                .filter(e -> NodeList.class.isAssignableFrom(e.getClass()))
                .map(NodeList.class::cast)
                .filter(e -> e.getLength() > 0)
                .map(e -> e.item(0))
                .map(Node::getParentNode)
                .filter(e -> e.getNodeType() == Node.ELEMENT_NODE)
                .filter(e -> Element.class.isAssignableFrom(e.getClass()))
                .map(Element.class::cast)
                .map(e -> e.getElementsByTagName("value"))
                .filter(e -> e.getLength() > 0)
                .map(e -> e.item(0));
    }

    public static void saveDocument(Document document, OutputStream bos) throws TransformerException {
        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        Transformer transformer = transformerFactory.newTransformer();

        transformer.setOutputProperty(OutputKeys.INDENT, "yes");
        transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4");

        DOMSource domSource = new DOMSource(document);

        StreamResult streamResult = new StreamResult(bos);

        transformer.transform(domSource, streamResult);
    }

    private static void createNewNode(Document document, String key, String value) {
        Element root = document.getDocumentElement();

        Element property = document.createElement("property");
        root.appendChild(property);

        Element nameNode = document.createElement("name");
        nameNode.setTextContent(key);

        Element valueNode = document.createElement("value");
        valueNode.setTextContent(value);

        property.appendChild(nameNode);
        property.appendChild(valueNode);
    }

    private static Document getOrCreate(String path) throws Exception {
        final File config = new File(path);
        ensureParentDir(config);

        final DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);

        final DocumentBuilder builder = factory.newDocumentBuilder();
        final Document document = config.exists()
                ? builder.parse(config)
                : builder.newDocument();

        if (document.getDocumentElement() != null) {
            document.getDocumentElement().normalize();
        }
        else {
            Element configuration = document.createElement("configuration");
            document.appendChild(configuration);
        }
        return document;
    }

    private static void ensureParentDir(File config) {
        if (config.exists()) return;

        final File parentDir = config.getParentFile();
        if (parentDir.exists()) return;
        if (parentDir.mkdirs()) return;

        throw new IllegalStateException("Unable to create the parent directory: " + parentDir.getAbsolutePath());
    }

    private static List<EnvValue> readEnv(String prefix) {
        final Map<String, String> env = System.getenv();

        final List<EnvValue> result = new ArrayList<>(env.size());
        for (Map.Entry<String, String> envValue : env.entrySet()) {
            final String name = envValue.getKey();
            if (!name.startsWith(prefix)) continue;

            final String value = envValue.getValue();
            result.add(new EnvValue(name.substring(prefix.length()), value));
        }
        return result;
    }

    private static void processEnvVariable(String path, String key, String value) throws Exception {
        final Document document = getOrCreate(path);

        final Optional<Node> valueNode = getValueNode(document, key);

        valueNode.ifPresent(e -> e.setTextContent(value));
        if (!valueNode.isPresent()) {
            createNewNode(document, key, value);
        }

        saveDocument(document, Files.newOutputStream(Paths.get(path)));
    }

    public static void main(String[] args) throws Exception {
        for (HadoopConfig conf : HadoopConfig.values()) {
            System.out.println("Processing " + conf.path);
            List<EnvValue> envValues = readEnv(conf.prefix);
            for (EnvValue envValue : envValues) {
                processEnvVariable(conf.getPath(), envValue.name, envValue.value);
            }
        }
    }

    private static final class EnvValue {
        private final String name;
        private final String value;

        private EnvValue(String name, String value) {
            this.name = name;
            this.value = value;
        }
    }

    private enum HadoopConfig {
        CORE_SITE("CORE-SITE.XML_", "core-site.xml"),
        HDFS_SITE("HDFS-SITE.XML_", "hdfs-site.xml"),
        MAPRED_SITE("MAPRED-SITE.XML_", "mapred-site.xml"),
        YARN_SITE("YARN-SITE.XML_", "yarn-site.xml"),
        CAPACITY_SCHEDULER("CAPACITY-SCHEDULER.XML_", "capacity-scheduler.xml"),
        HADOOP_POLICY("HADOOP-POLICY.XML_", "hadoop-policy.xml"),
        HDFS_RBF_SITE("HDFS-RBF-SITE.XML_", "hdfs-rbf-site.xml"),
        HTTPFS_SITE("HTTPFS-SITE.XML_", "httpfs-site.xml"),
        KMS_ACLS("KMS-ACLS.XML_", "kms-acls.xml"),
        KMS_SITE("KMS-SITE.XML_", "kms-site.xml");

        private final String prefix;
        private final String path;

        HadoopConfig(String prefix, String path) {
            this.prefix = prefix;
            this.path = path;
        }

        public String getPath() {
            final String hadoopConfDir = deduceHadoopConfigDir();

            return hadoopConfDir + "/" + path;
        }

        private static String deduceHadoopConfigDir() {
            final String hadoopConfDir = System.getenv("HADOOP_CONF_DIR");
            if (hadoopConfDir != null && !hadoopConfDir.trim().isEmpty()) {
                return hadoopConfDir.replaceAll("/+$", "");
            }

            return System.getenv("HADOOP_HOME") + "/etc/hadoop";
        }
    }
}

