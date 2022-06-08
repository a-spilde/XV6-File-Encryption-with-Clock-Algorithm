
_test_3:     file format elf32-i386


Disassembly of section .text:

00000000 <err>:

#define PGSIZE 4096

static int
err(char *msg, ...)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 ec 08             	sub    $0x8,%esp
    printf(1, "XV6_TEST_OUTPUT %s\n", msg);
   a:	83 ec 04             	sub    $0x4,%esp
   d:	ff 75 08             	pushl  0x8(%ebp)
  10:	68 a4 0a 00 00       	push   $0xaa4
  15:	6a 01                	push   $0x1
  17:	e8 be 06 00 00       	call   6da <printf>
  1c:	83 c4 10             	add    $0x10,%esp
    exit();
  1f:	e8 22 05 00 00       	call   546 <exit>

00000024 <main>:
}

int main(void)
{
  24:	f3 0f 1e fb          	endbr32 
  28:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  2c:	83 e4 f0             	and    $0xfffffff0,%esp
  2f:	ff 71 fc             	pushl  -0x4(%ecx)
  32:	55                   	push   %ebp
  33:	89 e5                	mov    %esp,%ebp
  35:	57                   	push   %edi
  36:	56                   	push   %esi
  37:	53                   	push   %ebx
  38:	51                   	push   %ecx
  39:	83 ec 28             	sub    $0x28,%esp

    //why doesnt it encrypt

    printf(1, "test_3: start\n");
  3c:	83 ec 08             	sub    $0x8,%esp
  3f:	68 b8 0a 00 00       	push   $0xab8
  44:	6a 01                	push   $0x1
  46:	e8 8f 06 00 00       	call   6da <printf>
  4b:	83 c4 10             	add    $0x10,%esp
    const uint PAGES_NUM = 1;
  4e:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
    char *buffer = sbrk(PGSIZE * sizeof(char));
  55:	83 ec 0c             	sub    $0xc,%esp
  58:	68 00 10 00 00       	push   $0x1000
  5d:	e8 6c 05 00 00       	call   5ce <sbrk>
  62:	83 c4 10             	add    $0x10,%esp
  65:	89 45 dc             	mov    %eax,-0x24(%ebp)
    while ((uint)buffer != 0x6000)
  68:	eb 13                	jmp    7d <main+0x59>
        buffer = sbrk(PGSIZE * sizeof(char));
  6a:	83 ec 0c             	sub    $0xc,%esp
  6d:	68 00 10 00 00       	push   $0x1000
  72:	e8 57 05 00 00       	call   5ce <sbrk>
  77:	83 c4 10             	add    $0x10,%esp
  7a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    while ((uint)buffer != 0x6000)
  7d:	81 7d dc 00 60 00 00 	cmpl   $0x6000,-0x24(%ebp)
  84:	75 e4                	jne    6a <main+0x46>

    // Allocate one pages of space
    printf(1, "test_3: Allocating page\n");
  86:	83 ec 08             	sub    $0x8,%esp
  89:	68 c7 0a 00 00       	push   $0xac7
  8e:	6a 01                	push   $0x1
  90:	e8 45 06 00 00       	call   6da <printf>
  95:	83 c4 10             	add    $0x10,%esp
    sbrk(PAGES_NUM * PGSIZE);
  98:	8b 45 d8             	mov    -0x28(%ebp),%eax
  9b:	c1 e0 0c             	shl    $0xc,%eax
  9e:	83 ec 0c             	sub    $0xc,%esp
  a1:	50                   	push   %eax
  a2:	e8 27 05 00 00       	call   5ce <sbrk>
  a7:	83 c4 10             	add    $0x10,%esp
    printf(1, "test_3: DONE allocating page\n");
  aa:	83 ec 08             	sub    $0x8,%esp
  ad:	68 e0 0a 00 00       	push   $0xae0
  b2:	6a 01                	push   $0x1
  b4:	e8 21 06 00 00       	call   6da <printf>
  b9:	83 c4 10             	add    $0x10,%esp
    struct pt_entry pt_entries[PAGES_NUM];
  bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  bf:	83 e8 01             	sub    $0x1,%eax
  c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  c8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  cf:	b8 10 00 00 00       	mov    $0x10,%eax
  d4:	83 e8 01             	sub    $0x1,%eax
  d7:	01 d0                	add    %edx,%eax
  d9:	bf 10 00 00 00       	mov    $0x10,%edi
  de:	ba 00 00 00 00       	mov    $0x0,%edx
  e3:	f7 f7                	div    %edi
  e5:	6b c0 10             	imul   $0x10,%eax,%eax
  e8:	89 c2                	mov    %eax,%edx
  ea:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  f0:	89 e6                	mov    %esp,%esi
  f2:	29 d6                	sub    %edx,%esi
  f4:	89 f2                	mov    %esi,%edx
  f6:	39 d4                	cmp    %edx,%esp
  f8:	74 10                	je     10a <main+0xe6>
  fa:	81 ec 00 10 00 00    	sub    $0x1000,%esp
 100:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
 107:	00 
 108:	eb ec                	jmp    f6 <main+0xd2>
 10a:	89 c2                	mov    %eax,%edx
 10c:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 112:	29 d4                	sub    %edx,%esp
 114:	89 c2                	mov    %eax,%edx
 116:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 11c:	85 d2                	test   %edx,%edx
 11e:	74 0d                	je     12d <main+0x109>
 120:	25 ff 0f 00 00       	and    $0xfff,%eax
 125:	83 e8 04             	sub    $0x4,%eax
 128:	01 e0                	add    %esp,%eax
 12a:	83 08 00             	orl    $0x0,(%eax)
 12d:	89 e0                	mov    %esp,%eax
 12f:	83 c0 03             	add    $0x3,%eax
 132:	c1 e8 02             	shr    $0x2,%eax
 135:	c1 e0 02             	shl    $0x2,%eax
 138:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int retval = getpgtable(pt_entries, PAGES_NUM, 0);
 13b:	8b 45 d8             	mov    -0x28(%ebp),%eax
 13e:	83 ec 04             	sub    $0x4,%esp
 141:	6a 00                	push   $0x0
 143:	50                   	push   %eax
 144:	ff 75 d0             	pushl  -0x30(%ebp)
 147:	e8 a2 04 00 00       	call   5ee <getpgtable>
 14c:	83 c4 10             	add    $0x10,%esp
 14f:	89 45 cc             	mov    %eax,-0x34(%ebp)
    if (retval == PAGES_NUM)
 152:	8b 45 d8             	mov    -0x28(%ebp),%eax
 155:	39 45 cc             	cmp    %eax,-0x34(%ebp)
 158:	0f 85 53 01 00 00    	jne    2b1 <main+0x28d>
    {
        for (int i = 0; i < retval; i++)
 15e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 165:	e9 39 01 00 00       	jmp    2a3 <main+0x27f>
                   i,
                   pt_entries[i].pdx,
                   pt_entries[i].ptx,
                   pt_entries[i].writable,
                   pt_entries[i].encrypted,
                   pt_entries[i].ref);
 16a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 16d:	8b 55 e0             	mov    -0x20(%ebp),%edx
 170:	0f b6 44 d0 07       	movzbl 0x7(%eax,%edx,8),%eax
 175:	83 e0 01             	and    $0x1,%eax
            printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n",
 178:	0f b6 f0             	movzbl %al,%esi
                   pt_entries[i].encrypted,
 17b:	8b 45 d0             	mov    -0x30(%ebp),%eax
 17e:	8b 55 e0             	mov    -0x20(%ebp),%edx
 181:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 186:	c0 e8 07             	shr    $0x7,%al
            printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n",
 189:	0f b6 d8             	movzbl %al,%ebx
                   pt_entries[i].writable,
 18c:	8b 45 d0             	mov    -0x30(%ebp),%eax
 18f:	8b 55 e0             	mov    -0x20(%ebp),%edx
 192:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 197:	c0 e8 05             	shr    $0x5,%al
 19a:	83 e0 01             	and    $0x1,%eax
            printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n",
 19d:	0f b6 c8             	movzbl %al,%ecx
                   pt_entries[i].ptx,
 1a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 1a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
 1a6:	8b 04 d0             	mov    (%eax,%edx,8),%eax
 1a9:	c1 e8 0a             	shr    $0xa,%eax
 1ac:	66 25 ff 03          	and    $0x3ff,%ax
            printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n",
 1b0:	0f b7 d0             	movzwl %ax,%edx
                   pt_entries[i].pdx,
 1b3:	8b 45 d0             	mov    -0x30(%ebp),%eax
 1b6:	8b 7d e0             	mov    -0x20(%ebp),%edi
 1b9:	0f b7 04 f8          	movzwl (%eax,%edi,8),%eax
 1bd:	66 25 ff 03          	and    $0x3ff,%ax
            printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n",
 1c1:	0f b7 c0             	movzwl %ax,%eax
 1c4:	56                   	push   %esi
 1c5:	53                   	push   %ebx
 1c6:	51                   	push   %ecx
 1c7:	52                   	push   %edx
 1c8:	50                   	push   %eax
 1c9:	ff 75 e0             	pushl  -0x20(%ebp)
 1cc:	68 00 0b 00 00       	push   $0xb00
 1d1:	6a 01                	push   $0x1
 1d3:	e8 02 05 00 00       	call   6da <printf>
 1d8:	83 c4 20             	add    $0x20,%esp

            if (dump_rawphymem(pt_entries[i].ppage * PGSIZE, buffer) != 0)
 1db:	8b 45 d0             	mov    -0x30(%ebp),%eax
 1de:	8b 55 e0             	mov    -0x20(%ebp),%edx
 1e1:	8b 44 d0 04          	mov    0x4(%eax,%edx,8),%eax
 1e5:	25 ff ff 0f 00       	and    $0xfffff,%eax
 1ea:	c1 e0 0c             	shl    $0xc,%eax
 1ed:	83 ec 08             	sub    $0x8,%esp
 1f0:	ff 75 dc             	pushl  -0x24(%ebp)
 1f3:	50                   	push   %eax
 1f4:	e8 fd 03 00 00       	call   5f6 <dump_rawphymem>
 1f9:	83 c4 10             	add    $0x10,%esp
 1fc:	85 c0                	test   %eax,%eax
 1fe:	74 10                	je     210 <main+0x1ec>
                err("dump_rawphymem return non-zero value\n");
 200:	83 ec 0c             	sub    $0xc,%esp
 203:	68 5c 0b 00 00       	push   $0xb5c
 208:	e8 f3 fd ff ff       	call   0 <err>
 20d:	83 c4 10             	add    $0x10,%esp

            for (int j = 0; j < PGSIZE; j++)
 210:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 217:	eb 79                	jmp    292 <main+0x26e>
            {
                if (buffer[j] != (char)0xFF)
 219:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 21c:	8b 45 dc             	mov    -0x24(%ebp),%eax
 21f:	01 d0                	add    %edx,%eax
 221:	0f b6 00             	movzbl (%eax),%eax
 224:	3c ff                	cmp    $0xff,%al
 226:	74 66                	je     28e <main+0x26a>
                {
                    printf(1, "XV6_TEST_OUTPUT: content is incorrect at address 0x%x: expected 0x%x, got 0x%x\n", ((uint)(pt_entries[i].pdx) << 22 | (pt_entries[i].ptx) << 12) + j, 0xFF, buffer[j] & 0xFF);
 228:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 22b:	8b 45 dc             	mov    -0x24(%ebp),%eax
 22e:	01 d0                	add    %edx,%eax
 230:	0f b6 00             	movzbl (%eax),%eax
 233:	0f be c0             	movsbl %al,%eax
 236:	0f b6 c0             	movzbl %al,%eax
 239:	8b 55 d0             	mov    -0x30(%ebp),%edx
 23c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 23f:	0f b7 14 ca          	movzwl (%edx,%ecx,8),%edx
 243:	66 81 e2 ff 03       	and    $0x3ff,%dx
 248:	0f b7 d2             	movzwl %dx,%edx
 24b:	89 d3                	mov    %edx,%ebx
 24d:	c1 e3 16             	shl    $0x16,%ebx
 250:	8b 55 d0             	mov    -0x30(%ebp),%edx
 253:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 256:	8b 14 ca             	mov    (%edx,%ecx,8),%edx
 259:	c1 ea 0a             	shr    $0xa,%edx
 25c:	66 81 e2 ff 03       	and    $0x3ff,%dx
 261:	0f b7 d2             	movzwl %dx,%edx
 264:	c1 e2 0c             	shl    $0xc,%edx
 267:	09 d3                	or     %edx,%ebx
 269:	89 d9                	mov    %ebx,%ecx
 26b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 26e:	01 ca                	add    %ecx,%edx
 270:	83 ec 0c             	sub    $0xc,%esp
 273:	50                   	push   %eax
 274:	68 ff 00 00 00       	push   $0xff
 279:	52                   	push   %edx
 27a:	68 84 0b 00 00       	push   $0xb84
 27f:	6a 01                	push   $0x1
 281:	e8 54 04 00 00       	call   6da <printf>
 286:	83 c4 20             	add    $0x20,%esp
                    exit();
 289:	e8 b8 02 00 00       	call   546 <exit>
            for (int j = 0; j < PGSIZE; j++)
 28e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 292:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
 299:	0f 8e 7a ff ff ff    	jle    219 <main+0x1f5>
        for (int i = 0; i < retval; i++)
 29f:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
 2a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
 2a6:	3b 45 cc             	cmp    -0x34(%ebp),%eax
 2a9:	0f 8c bb fe ff ff    	jl     16a <main+0x146>
 2af:	eb 15                	jmp    2c6 <main+0x2a2>
                }
            }
        }
    }
    else
        printf(1, "XV6_TEST_OUTPUT: getpgtable returned incorrect value: expected %d, got %d\n", PAGES_NUM, retval);
 2b1:	ff 75 cc             	pushl  -0x34(%ebp)
 2b4:	ff 75 d8             	pushl  -0x28(%ebp)
 2b7:	68 d4 0b 00 00       	push   $0xbd4
 2bc:	6a 01                	push   $0x1
 2be:	e8 17 04 00 00       	call   6da <printf>
 2c3:	83 c4 10             	add    $0x10,%esp

    exit();
 2c6:	e8 7b 02 00 00       	call   546 <exit>

000002cb <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 2cb:	55                   	push   %ebp
 2cc:	89 e5                	mov    %esp,%ebp
 2ce:	57                   	push   %edi
 2cf:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 2d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2d3:	8b 55 10             	mov    0x10(%ebp),%edx
 2d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d9:	89 cb                	mov    %ecx,%ebx
 2db:	89 df                	mov    %ebx,%edi
 2dd:	89 d1                	mov    %edx,%ecx
 2df:	fc                   	cld    
 2e0:	f3 aa                	rep stos %al,%es:(%edi)
 2e2:	89 ca                	mov    %ecx,%edx
 2e4:	89 fb                	mov    %edi,%ebx
 2e6:	89 5d 08             	mov    %ebx,0x8(%ebp)
 2e9:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 2ec:	90                   	nop
 2ed:	5b                   	pop    %ebx
 2ee:	5f                   	pop    %edi
 2ef:	5d                   	pop    %ebp
 2f0:	c3                   	ret    

000002f1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2f1:	f3 0f 1e fb          	endbr32 
 2f5:	55                   	push   %ebp
 2f6:	89 e5                	mov    %esp,%ebp
 2f8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2fb:	8b 45 08             	mov    0x8(%ebp),%eax
 2fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 301:	90                   	nop
 302:	8b 55 0c             	mov    0xc(%ebp),%edx
 305:	8d 42 01             	lea    0x1(%edx),%eax
 308:	89 45 0c             	mov    %eax,0xc(%ebp)
 30b:	8b 45 08             	mov    0x8(%ebp),%eax
 30e:	8d 48 01             	lea    0x1(%eax),%ecx
 311:	89 4d 08             	mov    %ecx,0x8(%ebp)
 314:	0f b6 12             	movzbl (%edx),%edx
 317:	88 10                	mov    %dl,(%eax)
 319:	0f b6 00             	movzbl (%eax),%eax
 31c:	84 c0                	test   %al,%al
 31e:	75 e2                	jne    302 <strcpy+0x11>
    ;
  return os;
 320:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 323:	c9                   	leave  
 324:	c3                   	ret    

00000325 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 325:	f3 0f 1e fb          	endbr32 
 329:	55                   	push   %ebp
 32a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 32c:	eb 08                	jmp    336 <strcmp+0x11>
    p++, q++;
 32e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 332:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 336:	8b 45 08             	mov    0x8(%ebp),%eax
 339:	0f b6 00             	movzbl (%eax),%eax
 33c:	84 c0                	test   %al,%al
 33e:	74 10                	je     350 <strcmp+0x2b>
 340:	8b 45 08             	mov    0x8(%ebp),%eax
 343:	0f b6 10             	movzbl (%eax),%edx
 346:	8b 45 0c             	mov    0xc(%ebp),%eax
 349:	0f b6 00             	movzbl (%eax),%eax
 34c:	38 c2                	cmp    %al,%dl
 34e:	74 de                	je     32e <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 350:	8b 45 08             	mov    0x8(%ebp),%eax
 353:	0f b6 00             	movzbl (%eax),%eax
 356:	0f b6 d0             	movzbl %al,%edx
 359:	8b 45 0c             	mov    0xc(%ebp),%eax
 35c:	0f b6 00             	movzbl (%eax),%eax
 35f:	0f b6 c0             	movzbl %al,%eax
 362:	29 c2                	sub    %eax,%edx
 364:	89 d0                	mov    %edx,%eax
}
 366:	5d                   	pop    %ebp
 367:	c3                   	ret    

00000368 <strlen>:

uint
strlen(const char *s)
{
 368:	f3 0f 1e fb          	endbr32 
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 372:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 379:	eb 04                	jmp    37f <strlen+0x17>
 37b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 37f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 382:	8b 45 08             	mov    0x8(%ebp),%eax
 385:	01 d0                	add    %edx,%eax
 387:	0f b6 00             	movzbl (%eax),%eax
 38a:	84 c0                	test   %al,%al
 38c:	75 ed                	jne    37b <strlen+0x13>
    ;
  return n;
 38e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 391:	c9                   	leave  
 392:	c3                   	ret    

00000393 <memset>:

void*
memset(void *dst, int c, uint n)
{
 393:	f3 0f 1e fb          	endbr32 
 397:	55                   	push   %ebp
 398:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 39a:	8b 45 10             	mov    0x10(%ebp),%eax
 39d:	50                   	push   %eax
 39e:	ff 75 0c             	pushl  0xc(%ebp)
 3a1:	ff 75 08             	pushl  0x8(%ebp)
 3a4:	e8 22 ff ff ff       	call   2cb <stosb>
 3a9:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3af:	c9                   	leave  
 3b0:	c3                   	ret    

000003b1 <strchr>:

char*
strchr(const char *s, char c)
{
 3b1:	f3 0f 1e fb          	endbr32 
 3b5:	55                   	push   %ebp
 3b6:	89 e5                	mov    %esp,%ebp
 3b8:	83 ec 04             	sub    $0x4,%esp
 3bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3be:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 3c1:	eb 14                	jmp    3d7 <strchr+0x26>
    if(*s == c)
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	0f b6 00             	movzbl (%eax),%eax
 3c9:	38 45 fc             	cmp    %al,-0x4(%ebp)
 3cc:	75 05                	jne    3d3 <strchr+0x22>
      return (char*)s;
 3ce:	8b 45 08             	mov    0x8(%ebp),%eax
 3d1:	eb 13                	jmp    3e6 <strchr+0x35>
  for(; *s; s++)
 3d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3d7:	8b 45 08             	mov    0x8(%ebp),%eax
 3da:	0f b6 00             	movzbl (%eax),%eax
 3dd:	84 c0                	test   %al,%al
 3df:	75 e2                	jne    3c3 <strchr+0x12>
  return 0;
 3e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3e6:	c9                   	leave  
 3e7:	c3                   	ret    

000003e8 <gets>:

char*
gets(char *buf, int max)
{
 3e8:	f3 0f 1e fb          	endbr32 
 3ec:	55                   	push   %ebp
 3ed:	89 e5                	mov    %esp,%ebp
 3ef:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 3f9:	eb 42                	jmp    43d <gets+0x55>
    cc = read(0, &c, 1);
 3fb:	83 ec 04             	sub    $0x4,%esp
 3fe:	6a 01                	push   $0x1
 400:	8d 45 ef             	lea    -0x11(%ebp),%eax
 403:	50                   	push   %eax
 404:	6a 00                	push   $0x0
 406:	e8 53 01 00 00       	call   55e <read>
 40b:	83 c4 10             	add    $0x10,%esp
 40e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 411:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 415:	7e 33                	jle    44a <gets+0x62>
      break;
    buf[i++] = c;
 417:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41a:	8d 50 01             	lea    0x1(%eax),%edx
 41d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 420:	89 c2                	mov    %eax,%edx
 422:	8b 45 08             	mov    0x8(%ebp),%eax
 425:	01 c2                	add    %eax,%edx
 427:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 42b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 42d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 431:	3c 0a                	cmp    $0xa,%al
 433:	74 16                	je     44b <gets+0x63>
 435:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 439:	3c 0d                	cmp    $0xd,%al
 43b:	74 0e                	je     44b <gets+0x63>
  for(i=0; i+1 < max; ){
 43d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 440:	83 c0 01             	add    $0x1,%eax
 443:	39 45 0c             	cmp    %eax,0xc(%ebp)
 446:	7f b3                	jg     3fb <gets+0x13>
 448:	eb 01                	jmp    44b <gets+0x63>
      break;
 44a:	90                   	nop
      break;
  }
  buf[i] = '\0';
 44b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 44e:	8b 45 08             	mov    0x8(%ebp),%eax
 451:	01 d0                	add    %edx,%eax
 453:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 456:	8b 45 08             	mov    0x8(%ebp),%eax
}
 459:	c9                   	leave  
 45a:	c3                   	ret    

0000045b <stat>:

int
stat(const char *n, struct stat *st)
{
 45b:	f3 0f 1e fb          	endbr32 
 45f:	55                   	push   %ebp
 460:	89 e5                	mov    %esp,%ebp
 462:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 465:	83 ec 08             	sub    $0x8,%esp
 468:	6a 00                	push   $0x0
 46a:	ff 75 08             	pushl  0x8(%ebp)
 46d:	e8 14 01 00 00       	call   586 <open>
 472:	83 c4 10             	add    $0x10,%esp
 475:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 478:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 47c:	79 07                	jns    485 <stat+0x2a>
    return -1;
 47e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 483:	eb 25                	jmp    4aa <stat+0x4f>
  r = fstat(fd, st);
 485:	83 ec 08             	sub    $0x8,%esp
 488:	ff 75 0c             	pushl  0xc(%ebp)
 48b:	ff 75 f4             	pushl  -0xc(%ebp)
 48e:	e8 0b 01 00 00       	call   59e <fstat>
 493:	83 c4 10             	add    $0x10,%esp
 496:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 499:	83 ec 0c             	sub    $0xc,%esp
 49c:	ff 75 f4             	pushl  -0xc(%ebp)
 49f:	e8 ca 00 00 00       	call   56e <close>
 4a4:	83 c4 10             	add    $0x10,%esp
  return r;
 4a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4aa:	c9                   	leave  
 4ab:	c3                   	ret    

000004ac <atoi>:

int
atoi(const char *s)
{
 4ac:	f3 0f 1e fb          	endbr32 
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4bd:	eb 25                	jmp    4e4 <atoi+0x38>
    n = n*10 + *s++ - '0';
 4bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4c2:	89 d0                	mov    %edx,%eax
 4c4:	c1 e0 02             	shl    $0x2,%eax
 4c7:	01 d0                	add    %edx,%eax
 4c9:	01 c0                	add    %eax,%eax
 4cb:	89 c1                	mov    %eax,%ecx
 4cd:	8b 45 08             	mov    0x8(%ebp),%eax
 4d0:	8d 50 01             	lea    0x1(%eax),%edx
 4d3:	89 55 08             	mov    %edx,0x8(%ebp)
 4d6:	0f b6 00             	movzbl (%eax),%eax
 4d9:	0f be c0             	movsbl %al,%eax
 4dc:	01 c8                	add    %ecx,%eax
 4de:	83 e8 30             	sub    $0x30,%eax
 4e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4e4:	8b 45 08             	mov    0x8(%ebp),%eax
 4e7:	0f b6 00             	movzbl (%eax),%eax
 4ea:	3c 2f                	cmp    $0x2f,%al
 4ec:	7e 0a                	jle    4f8 <atoi+0x4c>
 4ee:	8b 45 08             	mov    0x8(%ebp),%eax
 4f1:	0f b6 00             	movzbl (%eax),%eax
 4f4:	3c 39                	cmp    $0x39,%al
 4f6:	7e c7                	jle    4bf <atoi+0x13>
  return n;
 4f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4fb:	c9                   	leave  
 4fc:	c3                   	ret    

000004fd <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4fd:	f3 0f 1e fb          	endbr32 
 501:	55                   	push   %ebp
 502:	89 e5                	mov    %esp,%ebp
 504:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 507:	8b 45 08             	mov    0x8(%ebp),%eax
 50a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 50d:	8b 45 0c             	mov    0xc(%ebp),%eax
 510:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 513:	eb 17                	jmp    52c <memmove+0x2f>
    *dst++ = *src++;
 515:	8b 55 f8             	mov    -0x8(%ebp),%edx
 518:	8d 42 01             	lea    0x1(%edx),%eax
 51b:	89 45 f8             	mov    %eax,-0x8(%ebp)
 51e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 521:	8d 48 01             	lea    0x1(%eax),%ecx
 524:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 527:	0f b6 12             	movzbl (%edx),%edx
 52a:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 52c:	8b 45 10             	mov    0x10(%ebp),%eax
 52f:	8d 50 ff             	lea    -0x1(%eax),%edx
 532:	89 55 10             	mov    %edx,0x10(%ebp)
 535:	85 c0                	test   %eax,%eax
 537:	7f dc                	jg     515 <memmove+0x18>
  return vdst;
 539:	8b 45 08             	mov    0x8(%ebp),%eax
}
 53c:	c9                   	leave  
 53d:	c3                   	ret    

0000053e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 53e:	b8 01 00 00 00       	mov    $0x1,%eax
 543:	cd 40                	int    $0x40
 545:	c3                   	ret    

00000546 <exit>:
SYSCALL(exit)
 546:	b8 02 00 00 00       	mov    $0x2,%eax
 54b:	cd 40                	int    $0x40
 54d:	c3                   	ret    

0000054e <wait>:
SYSCALL(wait)
 54e:	b8 03 00 00 00       	mov    $0x3,%eax
 553:	cd 40                	int    $0x40
 555:	c3                   	ret    

00000556 <pipe>:
SYSCALL(pipe)
 556:	b8 04 00 00 00       	mov    $0x4,%eax
 55b:	cd 40                	int    $0x40
 55d:	c3                   	ret    

0000055e <read>:
SYSCALL(read)
 55e:	b8 05 00 00 00       	mov    $0x5,%eax
 563:	cd 40                	int    $0x40
 565:	c3                   	ret    

00000566 <write>:
SYSCALL(write)
 566:	b8 10 00 00 00       	mov    $0x10,%eax
 56b:	cd 40                	int    $0x40
 56d:	c3                   	ret    

0000056e <close>:
SYSCALL(close)
 56e:	b8 15 00 00 00       	mov    $0x15,%eax
 573:	cd 40                	int    $0x40
 575:	c3                   	ret    

00000576 <kill>:
SYSCALL(kill)
 576:	b8 06 00 00 00       	mov    $0x6,%eax
 57b:	cd 40                	int    $0x40
 57d:	c3                   	ret    

0000057e <exec>:
SYSCALL(exec)
 57e:	b8 07 00 00 00       	mov    $0x7,%eax
 583:	cd 40                	int    $0x40
 585:	c3                   	ret    

00000586 <open>:
SYSCALL(open)
 586:	b8 0f 00 00 00       	mov    $0xf,%eax
 58b:	cd 40                	int    $0x40
 58d:	c3                   	ret    

0000058e <mknod>:
SYSCALL(mknod)
 58e:	b8 11 00 00 00       	mov    $0x11,%eax
 593:	cd 40                	int    $0x40
 595:	c3                   	ret    

00000596 <unlink>:
SYSCALL(unlink)
 596:	b8 12 00 00 00       	mov    $0x12,%eax
 59b:	cd 40                	int    $0x40
 59d:	c3                   	ret    

0000059e <fstat>:
SYSCALL(fstat)
 59e:	b8 08 00 00 00       	mov    $0x8,%eax
 5a3:	cd 40                	int    $0x40
 5a5:	c3                   	ret    

000005a6 <link>:
SYSCALL(link)
 5a6:	b8 13 00 00 00       	mov    $0x13,%eax
 5ab:	cd 40                	int    $0x40
 5ad:	c3                   	ret    

000005ae <mkdir>:
SYSCALL(mkdir)
 5ae:	b8 14 00 00 00       	mov    $0x14,%eax
 5b3:	cd 40                	int    $0x40
 5b5:	c3                   	ret    

000005b6 <chdir>:
SYSCALL(chdir)
 5b6:	b8 09 00 00 00       	mov    $0x9,%eax
 5bb:	cd 40                	int    $0x40
 5bd:	c3                   	ret    

000005be <dup>:
SYSCALL(dup)
 5be:	b8 0a 00 00 00       	mov    $0xa,%eax
 5c3:	cd 40                	int    $0x40
 5c5:	c3                   	ret    

000005c6 <getpid>:
SYSCALL(getpid)
 5c6:	b8 0b 00 00 00       	mov    $0xb,%eax
 5cb:	cd 40                	int    $0x40
 5cd:	c3                   	ret    

000005ce <sbrk>:
SYSCALL(sbrk)
 5ce:	b8 0c 00 00 00       	mov    $0xc,%eax
 5d3:	cd 40                	int    $0x40
 5d5:	c3                   	ret    

000005d6 <sleep>:
SYSCALL(sleep)
 5d6:	b8 0d 00 00 00       	mov    $0xd,%eax
 5db:	cd 40                	int    $0x40
 5dd:	c3                   	ret    

000005de <uptime>:
SYSCALL(uptime)
 5de:	b8 0e 00 00 00       	mov    $0xe,%eax
 5e3:	cd 40                	int    $0x40
 5e5:	c3                   	ret    

000005e6 <mencrypt>:
SYSCALL(mencrypt)
 5e6:	b8 16 00 00 00       	mov    $0x16,%eax
 5eb:	cd 40                	int    $0x40
 5ed:	c3                   	ret    

000005ee <getpgtable>:
SYSCALL(getpgtable)
 5ee:	b8 17 00 00 00       	mov    $0x17,%eax
 5f3:	cd 40                	int    $0x40
 5f5:	c3                   	ret    

000005f6 <dump_rawphymem>:
SYSCALL(dump_rawphymem)
 5f6:	b8 18 00 00 00       	mov    $0x18,%eax
 5fb:	cd 40                	int    $0x40
 5fd:	c3                   	ret    

000005fe <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5fe:	f3 0f 1e fb          	endbr32 
 602:	55                   	push   %ebp
 603:	89 e5                	mov    %esp,%ebp
 605:	83 ec 18             	sub    $0x18,%esp
 608:	8b 45 0c             	mov    0xc(%ebp),%eax
 60b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 60e:	83 ec 04             	sub    $0x4,%esp
 611:	6a 01                	push   $0x1
 613:	8d 45 f4             	lea    -0xc(%ebp),%eax
 616:	50                   	push   %eax
 617:	ff 75 08             	pushl  0x8(%ebp)
 61a:	e8 47 ff ff ff       	call   566 <write>
 61f:	83 c4 10             	add    $0x10,%esp
}
 622:	90                   	nop
 623:	c9                   	leave  
 624:	c3                   	ret    

00000625 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 625:	f3 0f 1e fb          	endbr32 
 629:	55                   	push   %ebp
 62a:	89 e5                	mov    %esp,%ebp
 62c:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 62f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 636:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 63a:	74 17                	je     653 <printint+0x2e>
 63c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 640:	79 11                	jns    653 <printint+0x2e>
    neg = 1;
 642:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 649:	8b 45 0c             	mov    0xc(%ebp),%eax
 64c:	f7 d8                	neg    %eax
 64e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 651:	eb 06                	jmp    659 <printint+0x34>
  } else {
    x = xx;
 653:	8b 45 0c             	mov    0xc(%ebp),%eax
 656:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 659:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 660:	8b 4d 10             	mov    0x10(%ebp),%ecx
 663:	8b 45 ec             	mov    -0x14(%ebp),%eax
 666:	ba 00 00 00 00       	mov    $0x0,%edx
 66b:	f7 f1                	div    %ecx
 66d:	89 d1                	mov    %edx,%ecx
 66f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 672:	8d 50 01             	lea    0x1(%eax),%edx
 675:	89 55 f4             	mov    %edx,-0xc(%ebp)
 678:	0f b6 91 94 0e 00 00 	movzbl 0xe94(%ecx),%edx
 67f:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 683:	8b 4d 10             	mov    0x10(%ebp),%ecx
 686:	8b 45 ec             	mov    -0x14(%ebp),%eax
 689:	ba 00 00 00 00       	mov    $0x0,%edx
 68e:	f7 f1                	div    %ecx
 690:	89 45 ec             	mov    %eax,-0x14(%ebp)
 693:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 697:	75 c7                	jne    660 <printint+0x3b>
  if(neg)
 699:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 69d:	74 2d                	je     6cc <printint+0xa7>
    buf[i++] = '-';
 69f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a2:	8d 50 01             	lea    0x1(%eax),%edx
 6a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6a8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6ad:	eb 1d                	jmp    6cc <printint+0xa7>
    putc(fd, buf[i]);
 6af:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b5:	01 d0                	add    %edx,%eax
 6b7:	0f b6 00             	movzbl (%eax),%eax
 6ba:	0f be c0             	movsbl %al,%eax
 6bd:	83 ec 08             	sub    $0x8,%esp
 6c0:	50                   	push   %eax
 6c1:	ff 75 08             	pushl  0x8(%ebp)
 6c4:	e8 35 ff ff ff       	call   5fe <putc>
 6c9:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 6cc:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6d4:	79 d9                	jns    6af <printint+0x8a>
}
 6d6:	90                   	nop
 6d7:	90                   	nop
 6d8:	c9                   	leave  
 6d9:	c3                   	ret    

000006da <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6da:	f3 0f 1e fb          	endbr32 
 6de:	55                   	push   %ebp
 6df:	89 e5                	mov    %esp,%ebp
 6e1:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6e4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6eb:	8d 45 0c             	lea    0xc(%ebp),%eax
 6ee:	83 c0 04             	add    $0x4,%eax
 6f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6fb:	e9 59 01 00 00       	jmp    859 <printf+0x17f>
    c = fmt[i] & 0xff;
 700:	8b 55 0c             	mov    0xc(%ebp),%edx
 703:	8b 45 f0             	mov    -0x10(%ebp),%eax
 706:	01 d0                	add    %edx,%eax
 708:	0f b6 00             	movzbl (%eax),%eax
 70b:	0f be c0             	movsbl %al,%eax
 70e:	25 ff 00 00 00       	and    $0xff,%eax
 713:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 716:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 71a:	75 2c                	jne    748 <printf+0x6e>
      if(c == '%'){
 71c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 720:	75 0c                	jne    72e <printf+0x54>
        state = '%';
 722:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 729:	e9 27 01 00 00       	jmp    855 <printf+0x17b>
      } else {
        putc(fd, c);
 72e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 731:	0f be c0             	movsbl %al,%eax
 734:	83 ec 08             	sub    $0x8,%esp
 737:	50                   	push   %eax
 738:	ff 75 08             	pushl  0x8(%ebp)
 73b:	e8 be fe ff ff       	call   5fe <putc>
 740:	83 c4 10             	add    $0x10,%esp
 743:	e9 0d 01 00 00       	jmp    855 <printf+0x17b>
      }
    } else if(state == '%'){
 748:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 74c:	0f 85 03 01 00 00    	jne    855 <printf+0x17b>
      if(c == 'd'){
 752:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 756:	75 1e                	jne    776 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 758:	8b 45 e8             	mov    -0x18(%ebp),%eax
 75b:	8b 00                	mov    (%eax),%eax
 75d:	6a 01                	push   $0x1
 75f:	6a 0a                	push   $0xa
 761:	50                   	push   %eax
 762:	ff 75 08             	pushl  0x8(%ebp)
 765:	e8 bb fe ff ff       	call   625 <printint>
 76a:	83 c4 10             	add    $0x10,%esp
        ap++;
 76d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 771:	e9 d8 00 00 00       	jmp    84e <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 776:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 77a:	74 06                	je     782 <printf+0xa8>
 77c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 780:	75 1e                	jne    7a0 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 782:	8b 45 e8             	mov    -0x18(%ebp),%eax
 785:	8b 00                	mov    (%eax),%eax
 787:	6a 00                	push   $0x0
 789:	6a 10                	push   $0x10
 78b:	50                   	push   %eax
 78c:	ff 75 08             	pushl  0x8(%ebp)
 78f:	e8 91 fe ff ff       	call   625 <printint>
 794:	83 c4 10             	add    $0x10,%esp
        ap++;
 797:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 79b:	e9 ae 00 00 00       	jmp    84e <printf+0x174>
      } else if(c == 's'){
 7a0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7a4:	75 43                	jne    7e9 <printf+0x10f>
        s = (char*)*ap;
 7a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7a9:	8b 00                	mov    (%eax),%eax
 7ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7ae:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7b6:	75 25                	jne    7dd <printf+0x103>
          s = "(null)";
 7b8:	c7 45 f4 1f 0c 00 00 	movl   $0xc1f,-0xc(%ebp)
        while(*s != 0){
 7bf:	eb 1c                	jmp    7dd <printf+0x103>
          putc(fd, *s);
 7c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c4:	0f b6 00             	movzbl (%eax),%eax
 7c7:	0f be c0             	movsbl %al,%eax
 7ca:	83 ec 08             	sub    $0x8,%esp
 7cd:	50                   	push   %eax
 7ce:	ff 75 08             	pushl  0x8(%ebp)
 7d1:	e8 28 fe ff ff       	call   5fe <putc>
 7d6:	83 c4 10             	add    $0x10,%esp
          s++;
 7d9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 7dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e0:	0f b6 00             	movzbl (%eax),%eax
 7e3:	84 c0                	test   %al,%al
 7e5:	75 da                	jne    7c1 <printf+0xe7>
 7e7:	eb 65                	jmp    84e <printf+0x174>
        }
      } else if(c == 'c'){
 7e9:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7ed:	75 1d                	jne    80c <printf+0x132>
        putc(fd, *ap);
 7ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7f2:	8b 00                	mov    (%eax),%eax
 7f4:	0f be c0             	movsbl %al,%eax
 7f7:	83 ec 08             	sub    $0x8,%esp
 7fa:	50                   	push   %eax
 7fb:	ff 75 08             	pushl  0x8(%ebp)
 7fe:	e8 fb fd ff ff       	call   5fe <putc>
 803:	83 c4 10             	add    $0x10,%esp
        ap++;
 806:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 80a:	eb 42                	jmp    84e <printf+0x174>
      } else if(c == '%'){
 80c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 810:	75 17                	jne    829 <printf+0x14f>
        putc(fd, c);
 812:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 815:	0f be c0             	movsbl %al,%eax
 818:	83 ec 08             	sub    $0x8,%esp
 81b:	50                   	push   %eax
 81c:	ff 75 08             	pushl  0x8(%ebp)
 81f:	e8 da fd ff ff       	call   5fe <putc>
 824:	83 c4 10             	add    $0x10,%esp
 827:	eb 25                	jmp    84e <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 829:	83 ec 08             	sub    $0x8,%esp
 82c:	6a 25                	push   $0x25
 82e:	ff 75 08             	pushl  0x8(%ebp)
 831:	e8 c8 fd ff ff       	call   5fe <putc>
 836:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 839:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 83c:	0f be c0             	movsbl %al,%eax
 83f:	83 ec 08             	sub    $0x8,%esp
 842:	50                   	push   %eax
 843:	ff 75 08             	pushl  0x8(%ebp)
 846:	e8 b3 fd ff ff       	call   5fe <putc>
 84b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 84e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 855:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 859:	8b 55 0c             	mov    0xc(%ebp),%edx
 85c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85f:	01 d0                	add    %edx,%eax
 861:	0f b6 00             	movzbl (%eax),%eax
 864:	84 c0                	test   %al,%al
 866:	0f 85 94 fe ff ff    	jne    700 <printf+0x26>
    }
  }
}
 86c:	90                   	nop
 86d:	90                   	nop
 86e:	c9                   	leave  
 86f:	c3                   	ret    

00000870 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 870:	f3 0f 1e fb          	endbr32 
 874:	55                   	push   %ebp
 875:	89 e5                	mov    %esp,%ebp
 877:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 87a:	8b 45 08             	mov    0x8(%ebp),%eax
 87d:	83 e8 08             	sub    $0x8,%eax
 880:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 883:	a1 b0 0e 00 00       	mov    0xeb0,%eax
 888:	89 45 fc             	mov    %eax,-0x4(%ebp)
 88b:	eb 24                	jmp    8b1 <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 88d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 890:	8b 00                	mov    (%eax),%eax
 892:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 895:	72 12                	jb     8a9 <free+0x39>
 897:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 89d:	77 24                	ja     8c3 <free+0x53>
 89f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a2:	8b 00                	mov    (%eax),%eax
 8a4:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 8a7:	72 1a                	jb     8c3 <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ac:	8b 00                	mov    (%eax),%eax
 8ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8b7:	76 d4                	jbe    88d <free+0x1d>
 8b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bc:	8b 00                	mov    (%eax),%eax
 8be:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 8c1:	73 ca                	jae    88d <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c6:	8b 40 04             	mov    0x4(%eax),%eax
 8c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d3:	01 c2                	add    %eax,%edx
 8d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d8:	8b 00                	mov    (%eax),%eax
 8da:	39 c2                	cmp    %eax,%edx
 8dc:	75 24                	jne    902 <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 8de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e1:	8b 50 04             	mov    0x4(%eax),%edx
 8e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e7:	8b 00                	mov    (%eax),%eax
 8e9:	8b 40 04             	mov    0x4(%eax),%eax
 8ec:	01 c2                	add    %eax,%edx
 8ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f7:	8b 00                	mov    (%eax),%eax
 8f9:	8b 10                	mov    (%eax),%edx
 8fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fe:	89 10                	mov    %edx,(%eax)
 900:	eb 0a                	jmp    90c <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 902:	8b 45 fc             	mov    -0x4(%ebp),%eax
 905:	8b 10                	mov    (%eax),%edx
 907:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 90c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90f:	8b 40 04             	mov    0x4(%eax),%eax
 912:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 919:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91c:	01 d0                	add    %edx,%eax
 91e:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 921:	75 20                	jne    943 <free+0xd3>
    p->s.size += bp->s.size;
 923:	8b 45 fc             	mov    -0x4(%ebp),%eax
 926:	8b 50 04             	mov    0x4(%eax),%edx
 929:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92c:	8b 40 04             	mov    0x4(%eax),%eax
 92f:	01 c2                	add    %eax,%edx
 931:	8b 45 fc             	mov    -0x4(%ebp),%eax
 934:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 937:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93a:	8b 10                	mov    (%eax),%edx
 93c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93f:	89 10                	mov    %edx,(%eax)
 941:	eb 08                	jmp    94b <free+0xdb>
  } else
    p->s.ptr = bp;
 943:	8b 45 fc             	mov    -0x4(%ebp),%eax
 946:	8b 55 f8             	mov    -0x8(%ebp),%edx
 949:	89 10                	mov    %edx,(%eax)
  freep = p;
 94b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94e:	a3 b0 0e 00 00       	mov    %eax,0xeb0
}
 953:	90                   	nop
 954:	c9                   	leave  
 955:	c3                   	ret    

00000956 <morecore>:

static Header*
morecore(uint nu)
{
 956:	f3 0f 1e fb          	endbr32 
 95a:	55                   	push   %ebp
 95b:	89 e5                	mov    %esp,%ebp
 95d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 960:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 967:	77 07                	ja     970 <morecore+0x1a>
    nu = 4096;
 969:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 970:	8b 45 08             	mov    0x8(%ebp),%eax
 973:	c1 e0 03             	shl    $0x3,%eax
 976:	83 ec 0c             	sub    $0xc,%esp
 979:	50                   	push   %eax
 97a:	e8 4f fc ff ff       	call   5ce <sbrk>
 97f:	83 c4 10             	add    $0x10,%esp
 982:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 985:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 989:	75 07                	jne    992 <morecore+0x3c>
    return 0;
 98b:	b8 00 00 00 00       	mov    $0x0,%eax
 990:	eb 26                	jmp    9b8 <morecore+0x62>
  hp = (Header*)p;
 992:	8b 45 f4             	mov    -0xc(%ebp),%eax
 995:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 998:	8b 45 f0             	mov    -0x10(%ebp),%eax
 99b:	8b 55 08             	mov    0x8(%ebp),%edx
 99e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a4:	83 c0 08             	add    $0x8,%eax
 9a7:	83 ec 0c             	sub    $0xc,%esp
 9aa:	50                   	push   %eax
 9ab:	e8 c0 fe ff ff       	call   870 <free>
 9b0:	83 c4 10             	add    $0x10,%esp
  return freep;
 9b3:	a1 b0 0e 00 00       	mov    0xeb0,%eax
}
 9b8:	c9                   	leave  
 9b9:	c3                   	ret    

000009ba <malloc>:

void*
malloc(uint nbytes)
{
 9ba:	f3 0f 1e fb          	endbr32 
 9be:	55                   	push   %ebp
 9bf:	89 e5                	mov    %esp,%ebp
 9c1:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9c4:	8b 45 08             	mov    0x8(%ebp),%eax
 9c7:	83 c0 07             	add    $0x7,%eax
 9ca:	c1 e8 03             	shr    $0x3,%eax
 9cd:	83 c0 01             	add    $0x1,%eax
 9d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9d3:	a1 b0 0e 00 00       	mov    0xeb0,%eax
 9d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9df:	75 23                	jne    a04 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 9e1:	c7 45 f0 a8 0e 00 00 	movl   $0xea8,-0x10(%ebp)
 9e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9eb:	a3 b0 0e 00 00       	mov    %eax,0xeb0
 9f0:	a1 b0 0e 00 00       	mov    0xeb0,%eax
 9f5:	a3 a8 0e 00 00       	mov    %eax,0xea8
    base.s.size = 0;
 9fa:	c7 05 ac 0e 00 00 00 	movl   $0x0,0xeac
 a01:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a07:	8b 00                	mov    (%eax),%eax
 a09:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0f:	8b 40 04             	mov    0x4(%eax),%eax
 a12:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 a15:	77 4d                	ja     a64 <malloc+0xaa>
      if(p->s.size == nunits)
 a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1a:	8b 40 04             	mov    0x4(%eax),%eax
 a1d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 a20:	75 0c                	jne    a2e <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a25:	8b 10                	mov    (%eax),%edx
 a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2a:	89 10                	mov    %edx,(%eax)
 a2c:	eb 26                	jmp    a54 <malloc+0x9a>
      else {
        p->s.size -= nunits;
 a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a31:	8b 40 04             	mov    0x4(%eax),%eax
 a34:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a37:	89 c2                	mov    %eax,%edx
 a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a42:	8b 40 04             	mov    0x4(%eax),%eax
 a45:	c1 e0 03             	shl    $0x3,%eax
 a48:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a51:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a57:	a3 b0 0e 00 00       	mov    %eax,0xeb0
      return (void*)(p + 1);
 a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5f:	83 c0 08             	add    $0x8,%eax
 a62:	eb 3b                	jmp    a9f <malloc+0xe5>
    }
    if(p == freep)
 a64:	a1 b0 0e 00 00       	mov    0xeb0,%eax
 a69:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a6c:	75 1e                	jne    a8c <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 a6e:	83 ec 0c             	sub    $0xc,%esp
 a71:	ff 75 ec             	pushl  -0x14(%ebp)
 a74:	e8 dd fe ff ff       	call   956 <morecore>
 a79:	83 c4 10             	add    $0x10,%esp
 a7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a83:	75 07                	jne    a8c <malloc+0xd2>
        return 0;
 a85:	b8 00 00 00 00       	mov    $0x0,%eax
 a8a:	eb 13                	jmp    a9f <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a95:	8b 00                	mov    (%eax),%eax
 a97:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a9a:	e9 6d ff ff ff       	jmp    a0c <malloc+0x52>
  }
}
 a9f:	c9                   	leave  
 aa0:	c3                   	ret    
