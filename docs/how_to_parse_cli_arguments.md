[source](https://stackoverflow.com/a/14203146)

==========

#### Bash Space-Separated (e.g., `--option argument`)

&lt;!-- language-all: lang-bash --&gt;
```bash
cat &gt;/tmp/demo-space-separated.sh &lt;&lt;&#39;EOF&#39;
#!/bin/bash

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -e|--extension)
      EXTENSION=&quot;$2&quot;
      shift # past argument
      shift # past value
      ;;
    -s|--searchpath)
      SEARCHPATH=&quot;$2&quot;
      shift # past argument
      shift # past value
      ;;
    --default)
      DEFAULT=YES
      shift # past argument
      ;;
    -*|--*)
      echo &quot;Unknown option $1&quot;
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=(&quot;$1&quot;) # save positional arg
      shift # past argument
      ;;
  esac
done

set -- &quot;${POSITIONAL_ARGS[@]}&quot; # restore positional parameters

echo &quot;FILE EXTENSION  = ${EXTENSION}&quot;
echo &quot;SEARCH PATH     = ${SEARCHPATH}&quot;
echo &quot;DEFAULT         = ${DEFAULT}&quot;
echo &quot;Number files in SEARCH PATH with EXTENSION:&quot; $(ls -1 &quot;${SEARCHPATH}&quot;/*.&quot;${EXTENSION}&quot; | wc -l)

if [[ -n $1 ]]; then
    echo &quot;Last line of file specified as non-opt/last argument:&quot;
    tail -1 &quot;$1&quot;
fi
EOF

chmod +x /tmp/demo-space-separated.sh

/tmp/demo-space-separated.sh -e conf -s /etc /etc/hosts
```

##### Output from copy-pasting the block above

&lt;!-- language: lang-bash --&gt;
```bash
FILE EXTENSION  = conf
SEARCH PATH     = /etc
DEFAULT         =
Number files in SEARCH PATH with EXTENSION: 14
Last line of file specified as non-opt/last argument:
#93.184.216.34    example.com
```

##### Usage

    demo-space-separated.sh -e conf -s /etc /etc/hosts

---

#### Bash Equals-Separated (e.g., `--option=argument`)

```bash
cat &gt;/tmp/demo-equals-separated.sh &lt;&lt;&#39;EOF&#39;
#!/bin/bash

for i in &quot;$@&quot;; do
  case $i in
    -e=*|--extension=*)
      EXTENSION=&quot;${i#*=}&quot;
      shift # past argument=value
      ;;
    -s=*|--searchpath=*)
      SEARCHPATH=&quot;${i#*=}&quot;
      shift # past argument=value
      ;;
    --default)
      DEFAULT=YES
      shift # past argument with no value
      ;;
    -*|--*)
      echo &quot;Unknown option $i&quot;
      exit 1
      ;;
    *)
      ;;
  esac
done

echo &quot;FILE EXTENSION  = ${EXTENSION}&quot;
echo &quot;SEARCH PATH     = ${SEARCHPATH}&quot;
echo &quot;DEFAULT         = ${DEFAULT}&quot;
echo &quot;Number files in SEARCH PATH with EXTENSION:&quot; $(ls -1 &quot;${SEARCHPATH}&quot;/*.&quot;${EXTENSION}&quot; | wc -l)

if [[ -n $1 ]]; then
    echo &quot;Last line of file specified as non-opt/last argument:&quot;
    tail -1 $1
fi
EOF

chmod +x /tmp/demo-equals-separated.sh

/tmp/demo-equals-separated.sh -e=conf -s=/etc /etc/hosts
```

##### Output from copy-pasting the block above

&lt;!-- language: lang-bash --&gt;
```bash
FILE EXTENSION  = conf
SEARCH PATH     = /etc
DEFAULT         =
Number files in SEARCH PATH with EXTENSION: 14
Last line of file specified as non-opt/last argument:
#93.184.216.34    example.com
```

##### Usage

    demo-equals-separated.sh -e=conf -s=/etc /etc/hosts

---

To better understand `${i#*=}` search for &quot;Substring Removal&quot; in [this guide][1]. It is functionally equivalent to `` `sed &#39;s/[^=]*=//&#39; &lt;&lt;&lt; &quot;$i&quot;` `` which calls a needless subprocess or `` `echo &quot;$i&quot; | sed &#39;s/[^=]*=//&#39;` `` which calls *two* needless subprocesses. 

---

#### Using bash with getopt[s]

getopt(1) limitations (older, relatively-recent `getopt` versions): 

 - can&#39;t handle arguments that are empty strings
 - can&#39;t handle arguments with embedded whitespace

More recent `getopt` versions don&#39;t have these limitations. For more information, see these [docs][2].

---

#### POSIX getopts

Additionally, the POSIX shell and others offer `getopts` which doen&#39;t have these limitations. I&#39;ve included a simplistic `getopts` example.

```bash
cat &gt;/tmp/demo-getopts.sh &lt;&lt;&#39;EOF&#39;
#!/bin/sh

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
output_file=&quot;&quot;
verbose=0

while getopts &quot;h?vf:&quot; opt; do
  case &quot;$opt&quot; in
    h|\\?)
      show_help
      exit 0
      ;;
    v)  verbose=1
      ;;
    f)  output_file=$OPTARG
      ;;
  esac
done

shift $((OPTIND-1))

[ &quot;${1:-}&quot; = &quot;--&quot; ] &amp;&amp; shift

echo &quot;verbose=$verbose, output_file=&#39;$output_file&#39;, Leftovers: $@&quot;
EOF

chmod +x /tmp/demo-getopts.sh

/tmp/demo-getopts.sh -vf /etc/hosts foo bar
```

##### Output from copy-pasting the block above

&lt;!-- language: lang-none --&gt;
```bash
verbose=1, output_file=&#39;/etc/hosts&#39;, Leftovers: foo bar
```

##### Usage

    demo-getopts.sh -vf /etc/hosts foo bar


The advantages of `getopts` are:

 1. It&#39;s more portable, and will work in other shells like `dash`.  
 1. It can handle multiple single options like `-vf filename` in the typical Unix way, automatically.

The disadvantage of `getopts` is that it can only handle short options (`-h`, not `--help`) without additional code.

There is a [getopts tutorial][3] which explains what all of the syntax and variables mean.  In bash, there is also `help getopts`, which might be informative.


  [1]: http://tldp.org/LDP/abs/html/string-manipulation.html
  [2]: https://mywiki.wooledge.org/BashFAQ/035#getopts
  [3]: http://wiki.bash-hackers.org/howto/getopts_tutorial"
