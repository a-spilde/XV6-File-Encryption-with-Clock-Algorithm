
_test_1:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "ptentry.h"

#define PGSIZE 4096

int main(void) {
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 34             	sub    $0x34,%esp

    printf(1, "START OF TEST 1\n");
  15:	83 ec 08             	sub    $0x8,%esp
  18:	68 cc 09 00 00       	push   $0x9cc
  1d:	6a 01                	push   $0x1
  1f:	e8 e1 05 00 00       	call   605 <printf>
  24:	83 c4 10             	add    $0x10,%esp

    const uint PAGES_NUM = 100;
  27:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%ebp)
    printf(1, "TEST1: 0.5\n");
  2e:	83 ec 08             	sub    $0x8,%esp
  31:	68 dd 09 00 00       	push   $0x9dd
  36:	6a 01                	push   $0x1
  38:	e8 c8 05 00 00       	call   605 <printf>
  3d:	83 c4 10             	add    $0x10,%esp
    // Allocate one pages of space
    char *buffer = sbrk(PGSIZE * sizeof(char));
  40:	83 ec 0c             	sub    $0xc,%esp
  43:	68 00 10 00 00       	push   $0x1000
  48:	e8 ac 04 00 00       	call   4f9 <sbrk>
  4d:	83 c4 10             	add    $0x10,%esp
  50:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1, "TEST1: 1\n");
  53:	83 ec 08             	sub    $0x8,%esp
  56:	68 e9 09 00 00       	push   $0x9e9
  5b:	6a 01                	push   $0x1
  5d:	e8 a3 05 00 00       	call   605 <printf>
  62:	83 c4 10             	add    $0x10,%esp
    char *sp = buffer - PGSIZE;
  65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  68:	2d 00 10 00 00       	sub    $0x1000,%eax
  6d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    char *boundary = buffer - 2 * PGSIZE;
  70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  73:	2d 00 20 00 00       	sub    $0x2000,%eax
  78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    char *text = 0x0;
  7b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    uint text_pages = (uint) boundary / PGSIZE;
  82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  85:	c1 e8 0c             	shr    $0xc,%eax
  88:	89 45 dc             	mov    %eax,-0x24(%ebp)
    struct pt_entry pt_entries[PAGES_NUM];
  8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8e:	83 e8 01             	sub    $0x1,%eax
  91:	89 45 d8             	mov    %eax,-0x28(%ebp)
  94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  97:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  9e:	b8 10 00 00 00       	mov    $0x10,%eax
  a3:	83 e8 01             	sub    $0x1,%eax
  a6:	01 d0                	add    %edx,%eax
  a8:	b9 10 00 00 00       	mov    $0x10,%ecx
  ad:	ba 00 00 00 00       	mov    $0x0,%edx
  b2:	f7 f1                	div    %ecx
  b4:	6b c0 10             	imul   $0x10,%eax,%eax
  b7:	89 c2                	mov    %eax,%edx
  b9:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  bf:	89 e1                	mov    %esp,%ecx
  c1:	29 d1                	sub    %edx,%ecx
  c3:	89 ca                	mov    %ecx,%edx
  c5:	39 d4                	cmp    %edx,%esp
  c7:	74 10                	je     d9 <main+0xd9>
  c9:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  cf:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  d6:	00 
  d7:	eb ec                	jmp    c5 <main+0xc5>
  d9:	89 c2                	mov    %eax,%edx
  db:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  e1:	29 d4                	sub    %edx,%esp
  e3:	89 c2                	mov    %eax,%edx
  e5:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  eb:	85 d2                	test   %edx,%edx
  ed:	74 0d                	je     fc <main+0xfc>
  ef:	25 ff 0f 00 00       	and    $0xfff,%eax
  f4:	83 e8 04             	sub    $0x4,%eax
  f7:	01 e0                	add    %esp,%eax
  f9:	83 08 00             	orl    $0x0,(%eax)
  fc:	89 e0                	mov    %esp,%eax
  fe:	83 c0 03             	add    $0x3,%eax
 101:	c1 e8 02             	shr    $0x2,%eax
 104:	c1 e0 02             	shl    $0x2,%eax
 107:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    printf(1, "TEST1: 1.5\n");
 10a:	83 ec 08             	sub    $0x8,%esp
 10d:	68 f3 09 00 00       	push   $0x9f3
 112:	6a 01                	push   $0x1
 114:	e8 ec 04 00 00       	call   605 <printf>
 119:	83 c4 10             	add    $0x10,%esp
    sbrk(PAGES_NUM * PGSIZE);
 11c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 11f:	c1 e0 0c             	shl    $0xc,%eax
 122:	83 ec 0c             	sub    $0xc,%esp
 125:	50                   	push   %eax
 126:	e8 ce 03 00 00       	call   4f9 <sbrk>
 12b:	83 c4 10             	add    $0x10,%esp
    printf(1, "TEST1: 2\n");
 12e:	83 ec 08             	sub    $0x8,%esp
 131:	68 ff 09 00 00       	push   $0x9ff
 136:	6a 01                	push   $0x1
 138:	e8 c8 04 00 00       	call   605 <printf>
 13d:	83 c4 10             	add    $0x10,%esp

    

    printf(1, "text pages: %d\n", text_pages);
 140:	83 ec 04             	sub    $0x4,%esp
 143:	ff 75 dc             	pushl  -0x24(%ebp)
 146:	68 09 0a 00 00       	push   $0xa09
 14b:	6a 01                	push   $0x1
 14d:	e8 b3 04 00 00       	call   605 <printf>
 152:	83 c4 10             	add    $0x10,%esp

    for (int i = 0; i < text_pages; i++)
 155:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 15c:	eb 23                	jmp    181 <main+0x181>
        text[i * PGSIZE] = text[i * PGSIZE];
 15e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 161:	c1 e0 0c             	shl    $0xc,%eax
 164:	89 c2                	mov    %eax,%edx
 166:	8b 45 e0             	mov    -0x20(%ebp),%eax
 169:	01 d0                	add    %edx,%eax
 16b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 16e:	c1 e2 0c             	shl    $0xc,%edx
 171:	89 d1                	mov    %edx,%ecx
 173:	8b 55 e0             	mov    -0x20(%ebp),%edx
 176:	01 ca                	add    %ecx,%edx
 178:	0f b6 00             	movzbl (%eax),%eax
 17b:	88 02                	mov    %al,(%edx)
    for (int i = 0; i < text_pages; i++)
 17d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 181:	8b 45 f4             	mov    -0xc(%ebp),%eax
 184:	39 45 dc             	cmp    %eax,-0x24(%ebp)
 187:	77 d5                	ja     15e <main+0x15e>
    sp[0] = sp[0];
 189:	8b 45 e8             	mov    -0x18(%ebp),%eax
 18c:	0f b6 10             	movzbl (%eax),%edx
 18f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 192:	88 10                	mov    %dl,(%eax)
    buffer[0] = buffer[0];
 194:	8b 45 ec             	mov    -0x14(%ebp),%eax
 197:	0f b6 10             	movzbl (%eax),%edx
 19a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 19d:	88 10                	mov    %dl,(%eax)
    int expected_pages_num = (uint)buffer / PGSIZE;
 19f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1a2:	c1 e8 0c             	shr    $0xc,%eax
 1a5:	89 45 d0             	mov    %eax,-0x30(%ebp)


    int retval = getpgtable(pt_entries, 100, 1);
 1a8:	83 ec 04             	sub    $0x4,%esp
 1ab:	6a 01                	push   $0x1
 1ad:	6a 64                	push   $0x64
 1af:	ff 75 d4             	pushl  -0x2c(%ebp)
 1b2:	e8 62 03 00 00       	call   519 <getpgtable>
 1b7:	83 c4 10             	add    $0x10,%esp
 1ba:	89 45 cc             	mov    %eax,-0x34(%ebp)
    if (retval != expected_pages_num) {
 1bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
 1c0:	3b 45 d0             	cmp    -0x30(%ebp),%eax
 1c3:	74 1a                	je     1df <main+0x1df>
        printf(1, "XV6_TEST_OUTPUT: getpgtable returned incorrect value: expected %d, got %d\n", expected_pages_num, retval);
 1c5:	ff 75 cc             	pushl  -0x34(%ebp)
 1c8:	ff 75 d0             	pushl  -0x30(%ebp)
 1cb:	68 1c 0a 00 00       	push   $0xa1c
 1d0:	6a 01                	push   $0x1
 1d2:	e8 2e 04 00 00       	call   605 <printf>
 1d7:	83 c4 10             	add    $0x10,%esp
        exit();
 1da:	e8 92 02 00 00       	call   471 <exit>
    }
    printf(1, "XV6_TEST_OUTPUT PASS!\n");
 1df:	83 ec 08             	sub    $0x8,%esp
 1e2:	68 67 0a 00 00       	push   $0xa67
 1e7:	6a 01                	push   $0x1
 1e9:	e8 17 04 00 00       	call   605 <printf>
 1ee:	83 c4 10             	add    $0x10,%esp
    exit();
 1f1:	e8 7b 02 00 00       	call   471 <exit>

000001f6 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1f6:	55                   	push   %ebp
 1f7:	89 e5                	mov    %esp,%ebp
 1f9:	57                   	push   %edi
 1fa:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1fe:	8b 55 10             	mov    0x10(%ebp),%edx
 201:	8b 45 0c             	mov    0xc(%ebp),%eax
 204:	89 cb                	mov    %ecx,%ebx
 206:	89 df                	mov    %ebx,%edi
 208:	89 d1                	mov    %edx,%ecx
 20a:	fc                   	cld    
 20b:	f3 aa                	rep stos %al,%es:(%edi)
 20d:	89 ca                	mov    %ecx,%edx
 20f:	89 fb                	mov    %edi,%ebx
 211:	89 5d 08             	mov    %ebx,0x8(%ebp)
 214:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 217:	90                   	nop
 218:	5b                   	pop    %ebx
 219:	5f                   	pop    %edi
 21a:	5d                   	pop    %ebp
 21b:	c3                   	ret    

0000021c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 21c:	f3 0f 1e fb          	endbr32 
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 226:	8b 45 08             	mov    0x8(%ebp),%eax
 229:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 22c:	90                   	nop
 22d:	8b 55 0c             	mov    0xc(%ebp),%edx
 230:	8d 42 01             	lea    0x1(%edx),%eax
 233:	89 45 0c             	mov    %eax,0xc(%ebp)
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	8d 48 01             	lea    0x1(%eax),%ecx
 23c:	89 4d 08             	mov    %ecx,0x8(%ebp)
 23f:	0f b6 12             	movzbl (%edx),%edx
 242:	88 10                	mov    %dl,(%eax)
 244:	0f b6 00             	movzbl (%eax),%eax
 247:	84 c0                	test   %al,%al
 249:	75 e2                	jne    22d <strcpy+0x11>
    ;
  return os;
 24b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 24e:	c9                   	leave  
 24f:	c3                   	ret    

00000250 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 250:	f3 0f 1e fb          	endbr32 
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 257:	eb 08                	jmp    261 <strcmp+0x11>
    p++, q++;
 259:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 25d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	0f b6 00             	movzbl (%eax),%eax
 267:	84 c0                	test   %al,%al
 269:	74 10                	je     27b <strcmp+0x2b>
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	0f b6 10             	movzbl (%eax),%edx
 271:	8b 45 0c             	mov    0xc(%ebp),%eax
 274:	0f b6 00             	movzbl (%eax),%eax
 277:	38 c2                	cmp    %al,%dl
 279:	74 de                	je     259 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
 27e:	0f b6 00             	movzbl (%eax),%eax
 281:	0f b6 d0             	movzbl %al,%edx
 284:	8b 45 0c             	mov    0xc(%ebp),%eax
 287:	0f b6 00             	movzbl (%eax),%eax
 28a:	0f b6 c0             	movzbl %al,%eax
 28d:	29 c2                	sub    %eax,%edx
 28f:	89 d0                	mov    %edx,%eax
}
 291:	5d                   	pop    %ebp
 292:	c3                   	ret    

00000293 <strlen>:

uint
strlen(const char *s)
{
 293:	f3 0f 1e fb          	endbr32 
 297:	55                   	push   %ebp
 298:	89 e5                	mov    %esp,%ebp
 29a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 29d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2a4:	eb 04                	jmp    2aa <strlen+0x17>
 2a6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	01 d0                	add    %edx,%eax
 2b2:	0f b6 00             	movzbl (%eax),%eax
 2b5:	84 c0                	test   %al,%al
 2b7:	75 ed                	jne    2a6 <strlen+0x13>
    ;
  return n;
 2b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2bc:	c9                   	leave  
 2bd:	c3                   	ret    

000002be <memset>:

void*
memset(void *dst, int c, uint n)
{
 2be:	f3 0f 1e fb          	endbr32 
 2c2:	55                   	push   %ebp
 2c3:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 2c5:	8b 45 10             	mov    0x10(%ebp),%eax
 2c8:	50                   	push   %eax
 2c9:	ff 75 0c             	pushl  0xc(%ebp)
 2cc:	ff 75 08             	pushl  0x8(%ebp)
 2cf:	e8 22 ff ff ff       	call   1f6 <stosb>
 2d4:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2da:	c9                   	leave  
 2db:	c3                   	ret    

000002dc <strchr>:

char*
strchr(const char *s, char c)
{
 2dc:	f3 0f 1e fb          	endbr32 
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	83 ec 04             	sub    $0x4,%esp
 2e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e9:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2ec:	eb 14                	jmp    302 <strchr+0x26>
    if(*s == c)
 2ee:	8b 45 08             	mov    0x8(%ebp),%eax
 2f1:	0f b6 00             	movzbl (%eax),%eax
 2f4:	38 45 fc             	cmp    %al,-0x4(%ebp)
 2f7:	75 05                	jne    2fe <strchr+0x22>
      return (char*)s;
 2f9:	8b 45 08             	mov    0x8(%ebp),%eax
 2fc:	eb 13                	jmp    311 <strchr+0x35>
  for(; *s; s++)
 2fe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 302:	8b 45 08             	mov    0x8(%ebp),%eax
 305:	0f b6 00             	movzbl (%eax),%eax
 308:	84 c0                	test   %al,%al
 30a:	75 e2                	jne    2ee <strchr+0x12>
  return 0;
 30c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 311:	c9                   	leave  
 312:	c3                   	ret    

00000313 <gets>:

char*
gets(char *buf, int max)
{
 313:	f3 0f 1e fb          	endbr32 
 317:	55                   	push   %ebp
 318:	89 e5                	mov    %esp,%ebp
 31a:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 31d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 324:	eb 42                	jmp    368 <gets+0x55>
    cc = read(0, &c, 1);
 326:	83 ec 04             	sub    $0x4,%esp
 329:	6a 01                	push   $0x1
 32b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 32e:	50                   	push   %eax
 32f:	6a 00                	push   $0x0
 331:	e8 53 01 00 00       	call   489 <read>
 336:	83 c4 10             	add    $0x10,%esp
 339:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 33c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 340:	7e 33                	jle    375 <gets+0x62>
      break;
    buf[i++] = c;
 342:	8b 45 f4             	mov    -0xc(%ebp),%eax
 345:	8d 50 01             	lea    0x1(%eax),%edx
 348:	89 55 f4             	mov    %edx,-0xc(%ebp)
 34b:	89 c2                	mov    %eax,%edx
 34d:	8b 45 08             	mov    0x8(%ebp),%eax
 350:	01 c2                	add    %eax,%edx
 352:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 356:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 358:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 35c:	3c 0a                	cmp    $0xa,%al
 35e:	74 16                	je     376 <gets+0x63>
 360:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 364:	3c 0d                	cmp    $0xd,%al
 366:	74 0e                	je     376 <gets+0x63>
  for(i=0; i+1 < max; ){
 368:	8b 45 f4             	mov    -0xc(%ebp),%eax
 36b:	83 c0 01             	add    $0x1,%eax
 36e:	39 45 0c             	cmp    %eax,0xc(%ebp)
 371:	7f b3                	jg     326 <gets+0x13>
 373:	eb 01                	jmp    376 <gets+0x63>
      break;
 375:	90                   	nop
      break;
  }
  buf[i] = '\0';
 376:	8b 55 f4             	mov    -0xc(%ebp),%edx
 379:	8b 45 08             	mov    0x8(%ebp),%eax
 37c:	01 d0                	add    %edx,%eax
 37e:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 381:	8b 45 08             	mov    0x8(%ebp),%eax
}
 384:	c9                   	leave  
 385:	c3                   	ret    

00000386 <stat>:

int
stat(const char *n, struct stat *st)
{
 386:	f3 0f 1e fb          	endbr32 
 38a:	55                   	push   %ebp
 38b:	89 e5                	mov    %esp,%ebp
 38d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 390:	83 ec 08             	sub    $0x8,%esp
 393:	6a 00                	push   $0x0
 395:	ff 75 08             	pushl  0x8(%ebp)
 398:	e8 14 01 00 00       	call   4b1 <open>
 39d:	83 c4 10             	add    $0x10,%esp
 3a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3a7:	79 07                	jns    3b0 <stat+0x2a>
    return -1;
 3a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3ae:	eb 25                	jmp    3d5 <stat+0x4f>
  r = fstat(fd, st);
 3b0:	83 ec 08             	sub    $0x8,%esp
 3b3:	ff 75 0c             	pushl  0xc(%ebp)
 3b6:	ff 75 f4             	pushl  -0xc(%ebp)
 3b9:	e8 0b 01 00 00       	call   4c9 <fstat>
 3be:	83 c4 10             	add    $0x10,%esp
 3c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3c4:	83 ec 0c             	sub    $0xc,%esp
 3c7:	ff 75 f4             	pushl  -0xc(%ebp)
 3ca:	e8 ca 00 00 00       	call   499 <close>
 3cf:	83 c4 10             	add    $0x10,%esp
  return r;
 3d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3d5:	c9                   	leave  
 3d6:	c3                   	ret    

000003d7 <atoi>:

int
atoi(const char *s)
{
 3d7:	f3 0f 1e fb          	endbr32 
 3db:	55                   	push   %ebp
 3dc:	89 e5                	mov    %esp,%ebp
 3de:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3e8:	eb 25                	jmp    40f <atoi+0x38>
    n = n*10 + *s++ - '0';
 3ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3ed:	89 d0                	mov    %edx,%eax
 3ef:	c1 e0 02             	shl    $0x2,%eax
 3f2:	01 d0                	add    %edx,%eax
 3f4:	01 c0                	add    %eax,%eax
 3f6:	89 c1                	mov    %eax,%ecx
 3f8:	8b 45 08             	mov    0x8(%ebp),%eax
 3fb:	8d 50 01             	lea    0x1(%eax),%edx
 3fe:	89 55 08             	mov    %edx,0x8(%ebp)
 401:	0f b6 00             	movzbl (%eax),%eax
 404:	0f be c0             	movsbl %al,%eax
 407:	01 c8                	add    %ecx,%eax
 409:	83 e8 30             	sub    $0x30,%eax
 40c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 40f:	8b 45 08             	mov    0x8(%ebp),%eax
 412:	0f b6 00             	movzbl (%eax),%eax
 415:	3c 2f                	cmp    $0x2f,%al
 417:	7e 0a                	jle    423 <atoi+0x4c>
 419:	8b 45 08             	mov    0x8(%ebp),%eax
 41c:	0f b6 00             	movzbl (%eax),%eax
 41f:	3c 39                	cmp    $0x39,%al
 421:	7e c7                	jle    3ea <atoi+0x13>
  return n;
 423:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 426:	c9                   	leave  
 427:	c3                   	ret    

00000428 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 428:	f3 0f 1e fb          	endbr32 
 42c:	55                   	push   %ebp
 42d:	89 e5                	mov    %esp,%ebp
 42f:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 432:	8b 45 08             	mov    0x8(%ebp),%eax
 435:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 438:	8b 45 0c             	mov    0xc(%ebp),%eax
 43b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 43e:	eb 17                	jmp    457 <memmove+0x2f>
    *dst++ = *src++;
 440:	8b 55 f8             	mov    -0x8(%ebp),%edx
 443:	8d 42 01             	lea    0x1(%edx),%eax
 446:	89 45 f8             	mov    %eax,-0x8(%ebp)
 449:	8b 45 fc             	mov    -0x4(%ebp),%eax
 44c:	8d 48 01             	lea    0x1(%eax),%ecx
 44f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 452:	0f b6 12             	movzbl (%edx),%edx
 455:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 457:	8b 45 10             	mov    0x10(%ebp),%eax
 45a:	8d 50 ff             	lea    -0x1(%eax),%edx
 45d:	89 55 10             	mov    %edx,0x10(%ebp)
 460:	85 c0                	test   %eax,%eax
 462:	7f dc                	jg     440 <memmove+0x18>
  return vdst;
 464:	8b 45 08             	mov    0x8(%ebp),%eax
}
 467:	c9                   	leave  
 468:	c3                   	ret    

00000469 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 469:	b8 01 00 00 00       	mov    $0x1,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <exit>:
SYSCALL(exit)
 471:	b8 02 00 00 00       	mov    $0x2,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <wait>:
SYSCALL(wait)
 479:	b8 03 00 00 00       	mov    $0x3,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <pipe>:
SYSCALL(pipe)
 481:	b8 04 00 00 00       	mov    $0x4,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <read>:
SYSCALL(read)
 489:	b8 05 00 00 00       	mov    $0x5,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <write>:
SYSCALL(write)
 491:	b8 10 00 00 00       	mov    $0x10,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <close>:
SYSCALL(close)
 499:	b8 15 00 00 00       	mov    $0x15,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <kill>:
SYSCALL(kill)
 4a1:	b8 06 00 00 00       	mov    $0x6,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <exec>:
SYSCALL(exec)
 4a9:	b8 07 00 00 00       	mov    $0x7,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <open>:
SYSCALL(open)
 4b1:	b8 0f 00 00 00       	mov    $0xf,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <mknod>:
SYSCALL(mknod)
 4b9:	b8 11 00 00 00       	mov    $0x11,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <unlink>:
SYSCALL(unlink)
 4c1:	b8 12 00 00 00       	mov    $0x12,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <fstat>:
SYSCALL(fstat)
 4c9:	b8 08 00 00 00       	mov    $0x8,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <link>:
SYSCALL(link)
 4d1:	b8 13 00 00 00       	mov    $0x13,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <mkdir>:
SYSCALL(mkdir)
 4d9:	b8 14 00 00 00       	mov    $0x14,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <chdir>:
SYSCALL(chdir)
 4e1:	b8 09 00 00 00       	mov    $0x9,%eax
 4e6:	cd 40                	int    $0x40
 4e8:	c3                   	ret    

000004e9 <dup>:
SYSCALL(dup)
 4e9:	b8 0a 00 00 00       	mov    $0xa,%eax
 4ee:	cd 40                	int    $0x40
 4f0:	c3                   	ret    

000004f1 <getpid>:
SYSCALL(getpid)
 4f1:	b8 0b 00 00 00       	mov    $0xb,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <sbrk>:
SYSCALL(sbrk)
 4f9:	b8 0c 00 00 00       	mov    $0xc,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <sleep>:
SYSCALL(sleep)
 501:	b8 0d 00 00 00       	mov    $0xd,%eax
 506:	cd 40                	int    $0x40
 508:	c3                   	ret    

00000509 <uptime>:
SYSCALL(uptime)
 509:	b8 0e 00 00 00       	mov    $0xe,%eax
 50e:	cd 40                	int    $0x40
 510:	c3                   	ret    

00000511 <mencrypt>:
SYSCALL(mencrypt)
 511:	b8 16 00 00 00       	mov    $0x16,%eax
 516:	cd 40                	int    $0x40
 518:	c3                   	ret    

00000519 <getpgtable>:
SYSCALL(getpgtable)
 519:	b8 17 00 00 00       	mov    $0x17,%eax
 51e:	cd 40                	int    $0x40
 520:	c3                   	ret    

00000521 <dump_rawphymem>:
SYSCALL(dump_rawphymem)
 521:	b8 18 00 00 00       	mov    $0x18,%eax
 526:	cd 40                	int    $0x40
 528:	c3                   	ret    

00000529 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 529:	f3 0f 1e fb          	endbr32 
 52d:	55                   	push   %ebp
 52e:	89 e5                	mov    %esp,%ebp
 530:	83 ec 18             	sub    $0x18,%esp
 533:	8b 45 0c             	mov    0xc(%ebp),%eax
 536:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 539:	83 ec 04             	sub    $0x4,%esp
 53c:	6a 01                	push   $0x1
 53e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 541:	50                   	push   %eax
 542:	ff 75 08             	pushl  0x8(%ebp)
 545:	e8 47 ff ff ff       	call   491 <write>
 54a:	83 c4 10             	add    $0x10,%esp
}
 54d:	90                   	nop
 54e:	c9                   	leave  
 54f:	c3                   	ret    

00000550 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 550:	f3 0f 1e fb          	endbr32 
 554:	55                   	push   %ebp
 555:	89 e5                	mov    %esp,%ebp
 557:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 55a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 561:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 565:	74 17                	je     57e <printint+0x2e>
 567:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 56b:	79 11                	jns    57e <printint+0x2e>
    neg = 1;
 56d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 574:	8b 45 0c             	mov    0xc(%ebp),%eax
 577:	f7 d8                	neg    %eax
 579:	89 45 ec             	mov    %eax,-0x14(%ebp)
 57c:	eb 06                	jmp    584 <printint+0x34>
  } else {
    x = xx;
 57e:	8b 45 0c             	mov    0xc(%ebp),%eax
 581:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 584:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 58b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 58e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 591:	ba 00 00 00 00       	mov    $0x0,%edx
 596:	f7 f1                	div    %ecx
 598:	89 d1                	mov    %edx,%ecx
 59a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59d:	8d 50 01             	lea    0x1(%eax),%edx
 5a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5a3:	0f b6 91 cc 0c 00 00 	movzbl 0xccc(%ecx),%edx
 5aa:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 5ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5b4:	ba 00 00 00 00       	mov    $0x0,%edx
 5b9:	f7 f1                	div    %ecx
 5bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5c2:	75 c7                	jne    58b <printint+0x3b>
  if(neg)
 5c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5c8:	74 2d                	je     5f7 <printint+0xa7>
    buf[i++] = '-';
 5ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5cd:	8d 50 01             	lea    0x1(%eax),%edx
 5d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5d3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5d8:	eb 1d                	jmp    5f7 <printint+0xa7>
    putc(fd, buf[i]);
 5da:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e0:	01 d0                	add    %edx,%eax
 5e2:	0f b6 00             	movzbl (%eax),%eax
 5e5:	0f be c0             	movsbl %al,%eax
 5e8:	83 ec 08             	sub    $0x8,%esp
 5eb:	50                   	push   %eax
 5ec:	ff 75 08             	pushl  0x8(%ebp)
 5ef:	e8 35 ff ff ff       	call   529 <putc>
 5f4:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 5f7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ff:	79 d9                	jns    5da <printint+0x8a>
}
 601:	90                   	nop
 602:	90                   	nop
 603:	c9                   	leave  
 604:	c3                   	ret    

00000605 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 605:	f3 0f 1e fb          	endbr32 
 609:	55                   	push   %ebp
 60a:	89 e5                	mov    %esp,%ebp
 60c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 60f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 616:	8d 45 0c             	lea    0xc(%ebp),%eax
 619:	83 c0 04             	add    $0x4,%eax
 61c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 61f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 626:	e9 59 01 00 00       	jmp    784 <printf+0x17f>
    c = fmt[i] & 0xff;
 62b:	8b 55 0c             	mov    0xc(%ebp),%edx
 62e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 631:	01 d0                	add    %edx,%eax
 633:	0f b6 00             	movzbl (%eax),%eax
 636:	0f be c0             	movsbl %al,%eax
 639:	25 ff 00 00 00       	and    $0xff,%eax
 63e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 641:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 645:	75 2c                	jne    673 <printf+0x6e>
      if(c == '%'){
 647:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 64b:	75 0c                	jne    659 <printf+0x54>
        state = '%';
 64d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 654:	e9 27 01 00 00       	jmp    780 <printf+0x17b>
      } else {
        putc(fd, c);
 659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 65c:	0f be c0             	movsbl %al,%eax
 65f:	83 ec 08             	sub    $0x8,%esp
 662:	50                   	push   %eax
 663:	ff 75 08             	pushl  0x8(%ebp)
 666:	e8 be fe ff ff       	call   529 <putc>
 66b:	83 c4 10             	add    $0x10,%esp
 66e:	e9 0d 01 00 00       	jmp    780 <printf+0x17b>
      }
    } else if(state == '%'){
 673:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 677:	0f 85 03 01 00 00    	jne    780 <printf+0x17b>
      if(c == 'd'){
 67d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 681:	75 1e                	jne    6a1 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 683:	8b 45 e8             	mov    -0x18(%ebp),%eax
 686:	8b 00                	mov    (%eax),%eax
 688:	6a 01                	push   $0x1
 68a:	6a 0a                	push   $0xa
 68c:	50                   	push   %eax
 68d:	ff 75 08             	pushl  0x8(%ebp)
 690:	e8 bb fe ff ff       	call   550 <printint>
 695:	83 c4 10             	add    $0x10,%esp
        ap++;
 698:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 69c:	e9 d8 00 00 00       	jmp    779 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 6a1:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6a5:	74 06                	je     6ad <printf+0xa8>
 6a7:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6ab:	75 1e                	jne    6cb <printf+0xc6>
        printint(fd, *ap, 16, 0);
 6ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b0:	8b 00                	mov    (%eax),%eax
 6b2:	6a 00                	push   $0x0
 6b4:	6a 10                	push   $0x10
 6b6:	50                   	push   %eax
 6b7:	ff 75 08             	pushl  0x8(%ebp)
 6ba:	e8 91 fe ff ff       	call   550 <printint>
 6bf:	83 c4 10             	add    $0x10,%esp
        ap++;
 6c2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6c6:	e9 ae 00 00 00       	jmp    779 <printf+0x174>
      } else if(c == 's'){
 6cb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6cf:	75 43                	jne    714 <printf+0x10f>
        s = (char*)*ap;
 6d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d4:	8b 00                	mov    (%eax),%eax
 6d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6e1:	75 25                	jne    708 <printf+0x103>
          s = "(null)";
 6e3:	c7 45 f4 7e 0a 00 00 	movl   $0xa7e,-0xc(%ebp)
        while(*s != 0){
 6ea:	eb 1c                	jmp    708 <printf+0x103>
          putc(fd, *s);
 6ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ef:	0f b6 00             	movzbl (%eax),%eax
 6f2:	0f be c0             	movsbl %al,%eax
 6f5:	83 ec 08             	sub    $0x8,%esp
 6f8:	50                   	push   %eax
 6f9:	ff 75 08             	pushl  0x8(%ebp)
 6fc:	e8 28 fe ff ff       	call   529 <putc>
 701:	83 c4 10             	add    $0x10,%esp
          s++;
 704:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 708:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70b:	0f b6 00             	movzbl (%eax),%eax
 70e:	84 c0                	test   %al,%al
 710:	75 da                	jne    6ec <printf+0xe7>
 712:	eb 65                	jmp    779 <printf+0x174>
        }
      } else if(c == 'c'){
 714:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 718:	75 1d                	jne    737 <printf+0x132>
        putc(fd, *ap);
 71a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 71d:	8b 00                	mov    (%eax),%eax
 71f:	0f be c0             	movsbl %al,%eax
 722:	83 ec 08             	sub    $0x8,%esp
 725:	50                   	push   %eax
 726:	ff 75 08             	pushl  0x8(%ebp)
 729:	e8 fb fd ff ff       	call   529 <putc>
 72e:	83 c4 10             	add    $0x10,%esp
        ap++;
 731:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 735:	eb 42                	jmp    779 <printf+0x174>
      } else if(c == '%'){
 737:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 73b:	75 17                	jne    754 <printf+0x14f>
        putc(fd, c);
 73d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 740:	0f be c0             	movsbl %al,%eax
 743:	83 ec 08             	sub    $0x8,%esp
 746:	50                   	push   %eax
 747:	ff 75 08             	pushl  0x8(%ebp)
 74a:	e8 da fd ff ff       	call   529 <putc>
 74f:	83 c4 10             	add    $0x10,%esp
 752:	eb 25                	jmp    779 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 754:	83 ec 08             	sub    $0x8,%esp
 757:	6a 25                	push   $0x25
 759:	ff 75 08             	pushl  0x8(%ebp)
 75c:	e8 c8 fd ff ff       	call   529 <putc>
 761:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 764:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 767:	0f be c0             	movsbl %al,%eax
 76a:	83 ec 08             	sub    $0x8,%esp
 76d:	50                   	push   %eax
 76e:	ff 75 08             	pushl  0x8(%ebp)
 771:	e8 b3 fd ff ff       	call   529 <putc>
 776:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 779:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 780:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 784:	8b 55 0c             	mov    0xc(%ebp),%edx
 787:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78a:	01 d0                	add    %edx,%eax
 78c:	0f b6 00             	movzbl (%eax),%eax
 78f:	84 c0                	test   %al,%al
 791:	0f 85 94 fe ff ff    	jne    62b <printf+0x26>
    }
  }
}
 797:	90                   	nop
 798:	90                   	nop
 799:	c9                   	leave  
 79a:	c3                   	ret    

0000079b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79b:	f3 0f 1e fb          	endbr32 
 79f:	55                   	push   %ebp
 7a0:	89 e5                	mov    %esp,%ebp
 7a2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a5:	8b 45 08             	mov    0x8(%ebp),%eax
 7a8:	83 e8 08             	sub    $0x8,%eax
 7ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ae:	a1 e8 0c 00 00       	mov    0xce8,%eax
 7b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7b6:	eb 24                	jmp    7dc <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bb:	8b 00                	mov    (%eax),%eax
 7bd:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 7c0:	72 12                	jb     7d4 <free+0x39>
 7c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c8:	77 24                	ja     7ee <free+0x53>
 7ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cd:	8b 00                	mov    (%eax),%eax
 7cf:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7d2:	72 1a                	jb     7ee <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d7:	8b 00                	mov    (%eax),%eax
 7d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7df:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e2:	76 d4                	jbe    7b8 <free+0x1d>
 7e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e7:	8b 00                	mov    (%eax),%eax
 7e9:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7ec:	73 ca                	jae    7b8 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f1:	8b 40 04             	mov    0x4(%eax),%eax
 7f4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fe:	01 c2                	add    %eax,%edx
 800:	8b 45 fc             	mov    -0x4(%ebp),%eax
 803:	8b 00                	mov    (%eax),%eax
 805:	39 c2                	cmp    %eax,%edx
 807:	75 24                	jne    82d <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 809:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80c:	8b 50 04             	mov    0x4(%eax),%edx
 80f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 812:	8b 00                	mov    (%eax),%eax
 814:	8b 40 04             	mov    0x4(%eax),%eax
 817:	01 c2                	add    %eax,%edx
 819:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 81f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 822:	8b 00                	mov    (%eax),%eax
 824:	8b 10                	mov    (%eax),%edx
 826:	8b 45 f8             	mov    -0x8(%ebp),%eax
 829:	89 10                	mov    %edx,(%eax)
 82b:	eb 0a                	jmp    837 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 82d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 830:	8b 10                	mov    (%eax),%edx
 832:	8b 45 f8             	mov    -0x8(%ebp),%eax
 835:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 837:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83a:	8b 40 04             	mov    0x4(%eax),%eax
 83d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 844:	8b 45 fc             	mov    -0x4(%ebp),%eax
 847:	01 d0                	add    %edx,%eax
 849:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 84c:	75 20                	jne    86e <free+0xd3>
    p->s.size += bp->s.size;
 84e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 851:	8b 50 04             	mov    0x4(%eax),%edx
 854:	8b 45 f8             	mov    -0x8(%ebp),%eax
 857:	8b 40 04             	mov    0x4(%eax),%eax
 85a:	01 c2                	add    %eax,%edx
 85c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 862:	8b 45 f8             	mov    -0x8(%ebp),%eax
 865:	8b 10                	mov    (%eax),%edx
 867:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86a:	89 10                	mov    %edx,(%eax)
 86c:	eb 08                	jmp    876 <free+0xdb>
  } else
    p->s.ptr = bp;
 86e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 871:	8b 55 f8             	mov    -0x8(%ebp),%edx
 874:	89 10                	mov    %edx,(%eax)
  freep = p;
 876:	8b 45 fc             	mov    -0x4(%ebp),%eax
 879:	a3 e8 0c 00 00       	mov    %eax,0xce8
}
 87e:	90                   	nop
 87f:	c9                   	leave  
 880:	c3                   	ret    

00000881 <morecore>:

static Header*
morecore(uint nu)
{
 881:	f3 0f 1e fb          	endbr32 
 885:	55                   	push   %ebp
 886:	89 e5                	mov    %esp,%ebp
 888:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 88b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 892:	77 07                	ja     89b <morecore+0x1a>
    nu = 4096;
 894:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 89b:	8b 45 08             	mov    0x8(%ebp),%eax
 89e:	c1 e0 03             	shl    $0x3,%eax
 8a1:	83 ec 0c             	sub    $0xc,%esp
 8a4:	50                   	push   %eax
 8a5:	e8 4f fc ff ff       	call   4f9 <sbrk>
 8aa:	83 c4 10             	add    $0x10,%esp
 8ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8b0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8b4:	75 07                	jne    8bd <morecore+0x3c>
    return 0;
 8b6:	b8 00 00 00 00       	mov    $0x0,%eax
 8bb:	eb 26                	jmp    8e3 <morecore+0x62>
  hp = (Header*)p;
 8bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c6:	8b 55 08             	mov    0x8(%ebp),%edx
 8c9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cf:	83 c0 08             	add    $0x8,%eax
 8d2:	83 ec 0c             	sub    $0xc,%esp
 8d5:	50                   	push   %eax
 8d6:	e8 c0 fe ff ff       	call   79b <free>
 8db:	83 c4 10             	add    $0x10,%esp
  return freep;
 8de:	a1 e8 0c 00 00       	mov    0xce8,%eax
}
 8e3:	c9                   	leave  
 8e4:	c3                   	ret    

000008e5 <malloc>:

void*
malloc(uint nbytes)
{
 8e5:	f3 0f 1e fb          	endbr32 
 8e9:	55                   	push   %ebp
 8ea:	89 e5                	mov    %esp,%ebp
 8ec:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ef:	8b 45 08             	mov    0x8(%ebp),%eax
 8f2:	83 c0 07             	add    $0x7,%eax
 8f5:	c1 e8 03             	shr    $0x3,%eax
 8f8:	83 c0 01             	add    $0x1,%eax
 8fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8fe:	a1 e8 0c 00 00       	mov    0xce8,%eax
 903:	89 45 f0             	mov    %eax,-0x10(%ebp)
 906:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 90a:	75 23                	jne    92f <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 90c:	c7 45 f0 e0 0c 00 00 	movl   $0xce0,-0x10(%ebp)
 913:	8b 45 f0             	mov    -0x10(%ebp),%eax
 916:	a3 e8 0c 00 00       	mov    %eax,0xce8
 91b:	a1 e8 0c 00 00       	mov    0xce8,%eax
 920:	a3 e0 0c 00 00       	mov    %eax,0xce0
    base.s.size = 0;
 925:	c7 05 e4 0c 00 00 00 	movl   $0x0,0xce4
 92c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 932:	8b 00                	mov    (%eax),%eax
 934:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 937:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93a:	8b 40 04             	mov    0x4(%eax),%eax
 93d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 940:	77 4d                	ja     98f <malloc+0xaa>
      if(p->s.size == nunits)
 942:	8b 45 f4             	mov    -0xc(%ebp),%eax
 945:	8b 40 04             	mov    0x4(%eax),%eax
 948:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 94b:	75 0c                	jne    959 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 94d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 950:	8b 10                	mov    (%eax),%edx
 952:	8b 45 f0             	mov    -0x10(%ebp),%eax
 955:	89 10                	mov    %edx,(%eax)
 957:	eb 26                	jmp    97f <malloc+0x9a>
      else {
        p->s.size -= nunits;
 959:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95c:	8b 40 04             	mov    0x4(%eax),%eax
 95f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 962:	89 c2                	mov    %eax,%edx
 964:	8b 45 f4             	mov    -0xc(%ebp),%eax
 967:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 96a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96d:	8b 40 04             	mov    0x4(%eax),%eax
 970:	c1 e0 03             	shl    $0x3,%eax
 973:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 976:	8b 45 f4             	mov    -0xc(%ebp),%eax
 979:	8b 55 ec             	mov    -0x14(%ebp),%edx
 97c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 97f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 982:	a3 e8 0c 00 00       	mov    %eax,0xce8
      return (void*)(p + 1);
 987:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98a:	83 c0 08             	add    $0x8,%eax
 98d:	eb 3b                	jmp    9ca <malloc+0xe5>
    }
    if(p == freep)
 98f:	a1 e8 0c 00 00       	mov    0xce8,%eax
 994:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 997:	75 1e                	jne    9b7 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 999:	83 ec 0c             	sub    $0xc,%esp
 99c:	ff 75 ec             	pushl  -0x14(%ebp)
 99f:	e8 dd fe ff ff       	call   881 <morecore>
 9a4:	83 c4 10             	add    $0x10,%esp
 9a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9ae:	75 07                	jne    9b7 <malloc+0xd2>
        return 0;
 9b0:	b8 00 00 00 00       	mov    $0x0,%eax
 9b5:	eb 13                	jmp    9ca <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c0:	8b 00                	mov    (%eax),%eax
 9c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9c5:	e9 6d ff ff ff       	jmp    937 <malloc+0x52>
  }
}
 9ca:	c9                   	leave  
 9cb:	c3                   	ret    
