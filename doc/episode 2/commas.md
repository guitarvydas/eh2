I've created a simple Python script that removes redundant commas
```
#!/usr/bin/env python
import sys
sys.stdout.write(sys.stdin.read().replace(',)', ')').replace(',}', '}').replace(',]', ']'))
```

This needs
```
chmod +x commas.py
```