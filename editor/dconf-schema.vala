using Gee;

public class SchemaKey
{
    public Schema schema;
    public string name;
    public string type;
    public string default_value;
    public string? summary;
    public string? description;
    public string? gettext_domain;

    public SchemaKey(Xml.Node* node, Schema schema, string? gettext_domain)
    {
        this.schema = schema;
        this.gettext_domain = gettext_domain;

        for (Xml.Attr* prop = node->properties; prop != null; prop = prop->next)
        {
            if (prop->name == "name")
                name = prop->children->content;
            else if (prop->name == "type")
                type = prop->children->content;
            //else
            //    ?
        }

        //if (name == null || type == null)
        //    ?

        for (Xml.Node* child = node->children; child != null; child = child->next)
        {
            if (child->name == "default")
               default_value = child->children->content;
            else if (child->name == "summary")
               summary = child->children->content;
            else if (child->name == "description")
               description = child->children->content;
            //else
            //   ?
        }
        
        //if (default_value == null)
        //    ?
    }
}

public class Schema
{
    public SchemaList list;
    public string id;
    public string? path;
    public HashMap<string, SchemaKey> keys = new HashMap<string, SchemaKey>();

    public Schema(SchemaList list, Xml.Node* node, string? gettext_domain)
    {
        this.list = list;

        for (Xml.Attr* prop = node->properties; prop != null; prop = prop->next)
        {
            if (prop->name == "id")
                id = prop->children->content;
            else if (prop->name == "path")
                path = prop->children->content; // FIXME: Does the path have to end with '/'?
            else if (prop->name == "gettext-domain")
                gettext_domain = prop->children->content;
            //else
            //    ?
        }

        //if (id == null)
        //    ?

        for (Xml.Node* child = node->children; child != null; child = child->next)
        {
            if (child->name != "key")
               continue;
            SchemaKey key = new SchemaKey(child, this, gettext_domain);
            keys.set(key.name, key);
        }
    }
}

public class SchemaList
{
    public ArrayList<Schema> schemas = new ArrayList<Schema>();
    public HashMap<string, SchemaKey> keys = new HashMap<string, SchemaKey>();

    public void parse_file(string path)
    {
        Xml.Doc* doc = Xml.Parser.parse_file(path);
        if (doc == null)
            return;

        Xml.Node* root = doc->get_root_element();
        if (root == null)
            return;
        if (root->name != "schemalist")
            return;

        string? gettext_domain = null;
        for (Xml.Attr* prop = root->properties; prop != null; prop = prop->next)
        {
            if (prop->name == "gettext-domain")
                gettext_domain = prop->children->content;
        }

        for (Xml.Node* node = root->children; node != null; node = node->next)
        {
            if (node->name != "schema")
               continue;

            Schema schema = new Schema(this, node, gettext_domain);
            schemas.add(schema);
            if (schema.path == null)
            {
                // FIXME: What to do here?
                continue;
            }
            
            foreach (var key in schema.keys.values)
            {
                string full_name = schema.path + key.name;
                keys.set(full_name, key);
            }
        }

        delete doc;
    }

    public void load_directory(string dir) throws Error
    {
        File directory = File.new_for_path(dir);
        var i = directory.enumerate_children (FILE_ATTRIBUTE_STANDARD_NAME, 0, null);
        FileInfo info;
        while ((info = i.next_file (null)) != null) {
            string name = info.get_name();

            if (!name.has_suffix(".gschema.xml"))
                continue;

            string path = Path.build_filename(dir, name, null);
            debug("Loading schema: %s", path);
            parse_file(path);
        }
    }
}