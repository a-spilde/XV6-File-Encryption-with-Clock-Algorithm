
_test_8:     file format elf32-i386


Disassembly of section .text:

00000000 <err>:
#include "ptentry.h"

#define PGSIZE 4096

static int 
err(char *msg, ...) {
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 ec 08             	sub    $0x8,%esp
    printf(1, "XV6_TEST_OUTPUT %s\n", msg);
   a:	83 ec 04             	sub    $0x4,%esp
   d:	ff 75 08             	pushl  0x8(%ebp)
  10:	68 ac 0c 00 00       	push   $0xcac
  15:	6a 01                	push   $0x1
  17:	e8 c6 08 00 00       	call   8e2 <printf>
  1c:	83 c4 10             	add    $0x10,%esp
    exit();
  1f:	e8 2a 07 00 00       	call   74e <exit>

00000024 <access_all_dummy_pages>:
}


void access_all_dummy_pages(char **dummy_pages, uint len) {
  24:	f3 0f 1e fb          	endbr32 
  28:	55                   	push   %ebp
  29:	89 e5                	mov    %esp,%ebp
  2b:	83 ec 10             	sub    $0x10,%esp
    for (int i = 0; i < len; i++) {
  2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  35:	eb 1b                	jmp    52 <access_all_dummy_pages+0x2e>

        // printf(1, "test_8: accessing dummy page %d\n", i);
        char temp = dummy_pages[i][0];
  37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  3a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  41:	8b 45 08             	mov    0x8(%ebp),%eax
  44:	01 d0                	add    %edx,%eax
  46:	8b 00                	mov    (%eax),%eax
  48:	0f b6 00             	movzbl (%eax),%eax
  4b:	88 45 fb             	mov    %al,-0x5(%ebp)
    for (int i = 0; i < len; i++) {
  4e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  55:	39 45 0c             	cmp    %eax,0xc(%ebp)
  58:	77 dd                	ja     37 <access_all_dummy_pages+0x13>
        temp = temp;
        // printf(1, "test_8: accessED dummy page %d\n", i);
        
    }
    // printf(1, "\n");
}
  5a:	90                   	nop
  5b:	90                   	nop
  5c:	c9                   	leave  
  5d:	c3                   	ret    

0000005e <main>:

int main(void) { 
  5e:	f3 0f 1e fb          	endbr32 
  62:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  66:	83 e4 f0             	and    $0xfffffff0,%esp
  69:	ff 71 fc             	pushl  -0x4(%ecx)
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	57                   	push   %edi
  70:	56                   	push   %esi
  71:	53                   	push   %ebx
  72:	51                   	push   %ecx
  73:	83 ec 68             	sub    $0x68,%esp

    // printf(1, "\n\n\ntest_8: START\n");

    const uint PAGES_NUM = 32;
  76:	c7 45 c4 20 00 00 00 	movl   $0x20,-0x3c(%ebp)
    const uint expected_dummy_pages_num = 4;
  7d:	c7 45 c0 04 00 00 00 	movl   $0x4,-0x40(%ebp)
    // These pages are used to make sure the test result is consistent for different text pages number
    char *dummy_pages[expected_dummy_pages_num];
  84:	8b 45 c0             	mov    -0x40(%ebp),%eax
  87:	83 e8 01             	sub    $0x1,%eax
  8a:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  90:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  97:	b8 10 00 00 00       	mov    $0x10,%eax
  9c:	83 e8 01             	sub    $0x1,%eax
  9f:	01 d0                	add    %edx,%eax
  a1:	bf 10 00 00 00       	mov    $0x10,%edi
  a6:	ba 00 00 00 00       	mov    $0x0,%edx
  ab:	f7 f7                	div    %edi
  ad:	6b c0 10             	imul   $0x10,%eax,%eax
  b0:	89 c2                	mov    %eax,%edx
  b2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  b8:	89 e7                	mov    %esp,%edi
  ba:	29 d7                	sub    %edx,%edi
  bc:	89 fa                	mov    %edi,%edx
  be:	39 d4                	cmp    %edx,%esp
  c0:	74 10                	je     d2 <main+0x74>
  c2:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  c8:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  cf:	00 
  d0:	eb ec                	jmp    be <main+0x60>
  d2:	89 c2                	mov    %eax,%edx
  d4:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  da:	29 d4                	sub    %edx,%esp
  dc:	89 c2                	mov    %eax,%edx
  de:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  e4:	85 d2                	test   %edx,%edx
  e6:	74 0d                	je     f5 <main+0x97>
  e8:	25 ff 0f 00 00       	and    $0xfff,%eax
  ed:	83 e8 04             	sub    $0x4,%eax
  f0:	01 e0                	add    %esp,%eax
  f2:	83 08 00             	orl    $0x0,(%eax)
  f5:	89 e0                	mov    %esp,%eax
  f7:	83 c0 03             	add    $0x3,%eax
  fa:	c1 e8 02             	shr    $0x2,%eax
  fd:	c1 e0 02             	shl    $0x2,%eax
 100:	89 45 b8             	mov    %eax,-0x48(%ebp)
    char *buffer = sbrk(PGSIZE * sizeof(char));
 103:	83 ec 0c             	sub    $0xc,%esp
 106:	68 00 10 00 00       	push   $0x1000
 10b:	e8 c6 06 00 00       	call   7d6 <sbrk>
 110:	83 c4 10             	add    $0x10,%esp
 113:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    char *sp = buffer - PGSIZE;
 116:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 119:	2d 00 10 00 00       	sub    $0x1000,%eax
 11e:	89 45 b0             	mov    %eax,-0x50(%ebp)
    char *boundary = buffer - 2 * PGSIZE;
 121:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 124:	2d 00 20 00 00       	sub    $0x2000,%eax
 129:	89 45 ac             	mov    %eax,-0x54(%ebp)
    struct pt_entry pt_entries[PAGES_NUM];
 12c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 12f:	83 e8 01             	sub    $0x1,%eax
 132:	89 45 a8             	mov    %eax,-0x58(%ebp)
 135:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 138:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 13f:	b8 10 00 00 00       	mov    $0x10,%eax
 144:	83 e8 01             	sub    $0x1,%eax
 147:	01 d0                	add    %edx,%eax
 149:	bf 10 00 00 00       	mov    $0x10,%edi
 14e:	ba 00 00 00 00       	mov    $0x0,%edx
 153:	f7 f7                	div    %edi
 155:	6b c0 10             	imul   $0x10,%eax,%eax
 158:	89 c2                	mov    %eax,%edx
 15a:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
 160:	89 e6                	mov    %esp,%esi
 162:	29 d6                	sub    %edx,%esi
 164:	89 f2                	mov    %esi,%edx
 166:	39 d4                	cmp    %edx,%esp
 168:	74 10                	je     17a <main+0x11c>
 16a:	81 ec 00 10 00 00    	sub    $0x1000,%esp
 170:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
 177:	00 
 178:	eb ec                	jmp    166 <main+0x108>
 17a:	89 c2                	mov    %eax,%edx
 17c:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 182:	29 d4                	sub    %edx,%esp
 184:	89 c2                	mov    %eax,%edx
 186:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 18c:	85 d2                	test   %edx,%edx
 18e:	74 0d                	je     19d <main+0x13f>
 190:	25 ff 0f 00 00       	and    $0xfff,%eax
 195:	83 e8 04             	sub    $0x4,%eax
 198:	01 e0                	add    %esp,%eax
 19a:	83 08 00             	orl    $0x0,(%eax)
 19d:	89 e0                	mov    %esp,%eax
 19f:	83 c0 03             	add    $0x3,%eax
 1a2:	c1 e8 02             	shr    $0x2,%eax
 1a5:	c1 e0 02             	shl    $0x2,%eax
 1a8:	89 45 a4             	mov    %eax,-0x5c(%ebp)

    // printf(1, "test_8: 1\n");

    uint text_pages = (uint) boundary / PGSIZE;
 1ab:	8b 45 ac             	mov    -0x54(%ebp),%eax
 1ae:	c1 e8 0c             	shr    $0xc,%eax
 1b1:	89 45 a0             	mov    %eax,-0x60(%ebp)
    if (text_pages > expected_dummy_pages_num - 1)
 1b4:	8b 45 c0             	mov    -0x40(%ebp),%eax
 1b7:	83 e8 01             	sub    $0x1,%eax
 1ba:	39 45 a0             	cmp    %eax,-0x60(%ebp)
 1bd:	76 10                	jbe    1cf <main+0x171>
        err("XV6_TEST_OUTPUT: program size exceeds the maximum allowed size. Please let us know if this case happens\n");
 1bf:	83 ec 0c             	sub    $0xc,%esp
 1c2:	68 c0 0c 00 00       	push   $0xcc0
 1c7:	e8 34 fe ff ff       	call   0 <err>
 1cc:	83 c4 10             	add    $0x10,%esp

    // printf(1, "test_8: 2\n");
    
    for (int i = 0; i < text_pages; i++)
 1cf:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
 1d6:	eb 15                	jmp    1ed <main+0x18f>
        dummy_pages[i] = (char *)(i * PGSIZE);
 1d8:	8b 45 c8             	mov    -0x38(%ebp),%eax
 1db:	c1 e0 0c             	shl    $0xc,%eax
 1de:	89 c1                	mov    %eax,%ecx
 1e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
 1e3:	8b 55 c8             	mov    -0x38(%ebp),%edx
 1e6:	89 0c 90             	mov    %ecx,(%eax,%edx,4)
    for (int i = 0; i < text_pages; i++)
 1e9:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
 1ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
 1f0:	39 45 a0             	cmp    %eax,-0x60(%ebp)
 1f3:	77 e3                	ja     1d8 <main+0x17a>
    dummy_pages[text_pages] = sp;
 1f5:	8b 45 b8             	mov    -0x48(%ebp),%eax
 1f8:	8b 55 a0             	mov    -0x60(%ebp),%edx
 1fb:	8b 4d b0             	mov    -0x50(%ebp),%ecx
 1fe:	89 0c 90             	mov    %ecx,(%eax,%edx,4)

    // printf(1, "test_8: 3\n");

    for (int i = text_pages + 1; i < expected_dummy_pages_num; i++)
 201:	8b 45 a0             	mov    -0x60(%ebp),%eax
 204:	83 c0 01             	add    $0x1,%eax
 207:	89 45 cc             	mov    %eax,-0x34(%ebp)
 20a:	eb 1d                	jmp    229 <main+0x1cb>
        dummy_pages[i] = sbrk(PGSIZE * sizeof(char));
 20c:	83 ec 0c             	sub    $0xc,%esp
 20f:	68 00 10 00 00       	push   $0x1000
 214:	e8 bd 05 00 00       	call   7d6 <sbrk>
 219:	83 c4 10             	add    $0x10,%esp
 21c:	8b 55 b8             	mov    -0x48(%ebp),%edx
 21f:	8b 4d cc             	mov    -0x34(%ebp),%ecx
 222:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    for (int i = text_pages + 1; i < expected_dummy_pages_num; i++)
 225:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
 229:	8b 45 cc             	mov    -0x34(%ebp),%eax
 22c:	39 45 c0             	cmp    %eax,-0x40(%ebp)
 22f:	77 db                	ja     20c <main+0x1ae>
    
    // printf(1, "test_8: about to access all 4 dummy pages\n");

    // After this call, all the dummy pages including text pages and stack pages
    // should be resident in the clock queue.
    access_all_dummy_pages(dummy_pages, expected_dummy_pages_num);
 231:	83 ec 08             	sub    $0x8,%esp
 234:	ff 75 c0             	pushl  -0x40(%ebp)
 237:	ff 75 b8             	pushl  -0x48(%ebp)
 23a:	e8 e5 fd ff ff       	call   24 <access_all_dummy_pages>
 23f:	83 c4 10             	add    $0x10,%esp

    // printf(1, "test_8: about to bring buffer page into the clock queue index 4\n");

    // Bring the buffer page into the clock queue
    buffer[0] = buffer[0];
 242:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 245:	0f b6 10             	movzbl (%eax),%edx
 248:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 24b:	88 10                	mov    %dl,(%eax)
    // printf(1, "test_8: 6\n");

    // Now we should have expected_dummy_pages_num + 1 (buffer) pages in the clock queue
    // Fill up the remainig slot with heap-allocated page
    // and bring all of them into the clock queue
    int heap_pages_num = CLOCKSIZE - expected_dummy_pages_num - 1;
 24d:	b8 07 00 00 00       	mov    $0x7,%eax
 252:	2b 45 c0             	sub    -0x40(%ebp),%eax
 255:	89 45 9c             	mov    %eax,-0x64(%ebp)
    char *ptr = sbrk(heap_pages_num * PGSIZE * sizeof(char));
 258:	8b 45 9c             	mov    -0x64(%ebp),%eax
 25b:	c1 e0 0c             	shl    $0xc,%eax
 25e:	83 ec 0c             	sub    $0xc,%esp
 261:	50                   	push   %eax
 262:	e8 6f 05 00 00       	call   7d6 <sbrk>
 267:	83 c4 10             	add    $0x10,%esp
 26a:	89 45 98             	mov    %eax,-0x68(%ebp)
    ptr[heap_pages_num / 2 * PGSIZE] = 0xAA;
 26d:	8b 45 9c             	mov    -0x64(%ebp),%eax
 270:	89 c2                	mov    %eax,%edx
 272:	c1 ea 1f             	shr    $0x1f,%edx
 275:	01 d0                	add    %edx,%eax
 277:	d1 f8                	sar    %eax
 279:	c1 e0 0c             	shl    $0xc,%eax
 27c:	89 c2                	mov    %eax,%edx
 27e:	8b 45 98             	mov    -0x68(%ebp),%eax
 281:	01 d0                	add    %edx,%eax
 283:	c6 00 aa             	movb   $0xaa,(%eax)

    // printf(1, "test_8: 7\n");

    for (int i = 0; i < heap_pages_num; i++) {
 286:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
 28d:	eb 31                	jmp    2c0 <main+0x262>
      for (int j = 0; j < PGSIZE; j++) {
 28f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 296:	eb 1b                	jmp    2b3 <main+0x255>
        ptr[i * PGSIZE + j] = 0xAA;
 298:	8b 45 d0             	mov    -0x30(%ebp),%eax
 29b:	c1 e0 0c             	shl    $0xc,%eax
 29e:	89 c2                	mov    %eax,%edx
 2a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 2a3:	01 d0                	add    %edx,%eax
 2a5:	89 c2                	mov    %eax,%edx
 2a7:	8b 45 98             	mov    -0x68(%ebp),%eax
 2aa:	01 d0                	add    %edx,%eax
 2ac:	c6 00 aa             	movb   $0xaa,(%eax)
      for (int j = 0; j < PGSIZE; j++) {
 2af:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
 2b3:	81 7d d4 ff 0f 00 00 	cmpl   $0xfff,-0x2c(%ebp)
 2ba:	7e dc                	jle    298 <main+0x23a>
    for (int i = 0; i < heap_pages_num; i++) {
 2bc:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
 2c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 2c3:	3b 45 9c             	cmp    -0x64(%ebp),%eax
 2c6:	7c c7                	jl     28f <main+0x231>

    // printf(1, "test_8: 8\n");
    
    // An extra page which will trigger the page eviction
    // This eviction will evict page 0
    char* extra_pages = sbrk(PGSIZE * sizeof(char));
 2c8:	83 ec 0c             	sub    $0xc,%esp
 2cb:	68 00 10 00 00       	push   $0x1000
 2d0:	e8 01 05 00 00       	call   7d6 <sbrk>
 2d5:	83 c4 10             	add    $0x10,%esp
 2d8:	89 45 94             	mov    %eax,-0x6c(%ebp)
    for (int j = 0; j < PGSIZE; j++) {
 2db:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
 2e2:	eb 0f                	jmp    2f3 <main+0x295>
      extra_pages[j] = 0xAA;
 2e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
 2e7:	8b 45 94             	mov    -0x6c(%ebp),%eax
 2ea:	01 d0                	add    %edx,%eax
 2ec:	c6 00 aa             	movb   $0xaa,(%eax)
    for (int j = 0; j < PGSIZE; j++) {
 2ef:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
 2f3:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
 2fa:	7e e8                	jle    2e4 <main+0x286>
    // printf(1, "test_8: 9\n");

    // Bring all the dummy pages and buffer back to the 
    // clock queue and reset their ref to 1
    // At this time, the first heap-allocated page is ensured to be evicted
    access_all_dummy_pages(dummy_pages, expected_dummy_pages_num);
 2fc:	83 ec 08             	sub    $0x8,%esp
 2ff:	ff 75 c0             	pushl  -0x40(%ebp)
 302:	ff 75 b8             	pushl  -0x48(%ebp)
 305:	e8 1a fd ff ff       	call   24 <access_all_dummy_pages>
 30a:	83 c4 10             	add    $0x10,%esp

    // printf(1, "test_8: 9.5\n");

    buffer[0] = buffer[0];
 30d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 310:	0f b6 10             	movzbl (%eax),%edx
 313:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 316:	88 10                	mov    %dl,(%eax)

    // printf(1, "test_8: 10\n");

    // Verify that the pages pointed by the ptr is evicted
    int retval = getpgtable(pt_entries, heap_pages_num + 1, 0);
 318:	8b 45 9c             	mov    -0x64(%ebp),%eax
 31b:	83 c0 01             	add    $0x1,%eax
 31e:	83 ec 04             	sub    $0x4,%esp
 321:	6a 00                	push   $0x0
 323:	50                   	push   %eax
 324:	ff 75 a4             	pushl  -0x5c(%ebp)
 327:	e8 ca 04 00 00       	call   7f6 <getpgtable>
 32c:	83 c4 10             	add    $0x10,%esp
 32f:	89 45 90             	mov    %eax,-0x70(%ebp)
    if (retval == heap_pages_num + 1) {
 332:	8b 45 9c             	mov    -0x64(%ebp),%eax
 335:	83 c0 01             	add    $0x1,%eax
 338:	39 45 90             	cmp    %eax,-0x70(%ebp)
 33b:	0f 85 78 01 00 00    	jne    4b9 <main+0x45b>
      for (int i = 0; i < retval; i++) {
 341:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 348:	e9 5e 01 00 00       	jmp    4ab <main+0x44d>
              i,
              pt_entries[i].pdx,
              pt_entries[i].ptx,
              pt_entries[i].writable,
              pt_entries[i].encrypted,
              pt_entries[i].ref
 34d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 350:	8b 55 dc             	mov    -0x24(%ebp),%edx
 353:	0f b6 44 d0 07       	movzbl 0x7(%eax,%edx,8),%eax
 358:	83 e0 01             	and    $0x1,%eax
          printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 35b:	0f b6 f0             	movzbl %al,%esi
              pt_entries[i].encrypted,
 35e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 361:	8b 55 dc             	mov    -0x24(%ebp),%edx
 364:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 369:	c0 e8 07             	shr    $0x7,%al
          printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 36c:	0f b6 d8             	movzbl %al,%ebx
              pt_entries[i].writable,
 36f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 372:	8b 55 dc             	mov    -0x24(%ebp),%edx
 375:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 37a:	c0 e8 05             	shr    $0x5,%al
 37d:	83 e0 01             	and    $0x1,%eax
          printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 380:	0f b6 c8             	movzbl %al,%ecx
              pt_entries[i].ptx,
 383:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 386:	8b 55 dc             	mov    -0x24(%ebp),%edx
 389:	8b 04 d0             	mov    (%eax,%edx,8),%eax
 38c:	c1 e8 0a             	shr    $0xa,%eax
 38f:	66 25 ff 03          	and    $0x3ff,%ax
          printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 393:	0f b7 d0             	movzwl %ax,%edx
              pt_entries[i].pdx,
 396:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 399:	8b 7d dc             	mov    -0x24(%ebp),%edi
 39c:	0f b7 04 f8          	movzwl (%eax,%edi,8),%eax
 3a0:	66 25 ff 03          	and    $0x3ff,%ax
          printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 3a4:	0f b7 c0             	movzwl %ax,%eax
 3a7:	56                   	push   %esi
 3a8:	53                   	push   %ebx
 3a9:	51                   	push   %ecx
 3aa:	52                   	push   %edx
 3ab:	50                   	push   %eax
 3ac:	ff 75 dc             	pushl  -0x24(%ebp)
 3af:	68 2c 0d 00 00       	push   $0xd2c
 3b4:	6a 01                	push   $0x1
 3b6:	e8 27 05 00 00       	call   8e2 <printf>
 3bb:	83 c4 20             	add    $0x20,%esp
          ); 
          
          uint expected = 0xAA;
 3be:	c7 45 e0 aa 00 00 00 	movl   $0xaa,-0x20(%ebp)
          if (pt_entries[i].encrypted)
 3c5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 3c8:	8b 55 dc             	mov    -0x24(%ebp),%edx
 3cb:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 3d0:	c0 e8 07             	shr    $0x7,%al
 3d3:	84 c0                	test   %al,%al
 3d5:	74 07                	je     3de <main+0x380>
            expected = ~0xAA;
 3d7:	c7 45 e0 55 ff ff ff 	movl   $0xffffff55,-0x20(%ebp)

          if (dump_rawphymem(pt_entries[i].ppage * PGSIZE, buffer) != 0)
 3de:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 3e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
 3e4:	8b 44 d0 04          	mov    0x4(%eax,%edx,8),%eax
 3e8:	25 ff ff 0f 00       	and    $0xfffff,%eax
 3ed:	c1 e0 0c             	shl    $0xc,%eax
 3f0:	83 ec 08             	sub    $0x8,%esp
 3f3:	ff 75 b4             	pushl  -0x4c(%ebp)
 3f6:	50                   	push   %eax
 3f7:	e8 02 04 00 00       	call   7fe <dump_rawphymem>
 3fc:	83 c4 10             	add    $0x10,%esp
 3ff:	85 c0                	test   %eax,%eax
 401:	74 10                	je     413 <main+0x3b5>
              err("dump_rawphymem return non-zero value\n");
 403:	83 ec 0c             	sub    $0xc,%esp
 406:	68 88 0d 00 00       	push   $0xd88
 40b:	e8 f0 fb ff ff       	call   0 <err>
 410:	83 c4 10             	add    $0x10,%esp
          
          for (int j = 0; j < PGSIZE; j++) {
 413:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 41a:	eb 7e                	jmp    49a <main+0x43c>
              if (buffer[j] != (char)expected) {
 41c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 41f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 422:	01 d0                	add    %edx,%eax
 424:	0f b6 00             	movzbl (%eax),%eax
 427:	8b 55 e0             	mov    -0x20(%ebp),%edx
 42a:	38 d0                	cmp    %dl,%al
 42c:	74 68                	je     496 <main+0x438>
                  // err("physical memory is dumped incorrectly\n");
                    printf(1, "XV6_TEST_OUTPUT: content is incorrect at address 0x%x: expected 0x%x, got 0x%x\n", ((uint)(pt_entries[i].pdx) << 22 | (pt_entries[i].ptx) << 12) + j ,expected & 0xFF, buffer[j] & 0xFF);
 42e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 431:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 434:	01 d0                	add    %edx,%eax
 436:	0f b6 00             	movzbl (%eax),%eax
 439:	0f be c0             	movsbl %al,%eax
 43c:	0f b6 d0             	movzbl %al,%edx
 43f:	8b 45 e0             	mov    -0x20(%ebp),%eax
 442:	0f b6 c0             	movzbl %al,%eax
 445:	8b 4d a4             	mov    -0x5c(%ebp),%ecx
 448:	8b 5d dc             	mov    -0x24(%ebp),%ebx
 44b:	0f b7 0c d9          	movzwl (%ecx,%ebx,8),%ecx
 44f:	66 81 e1 ff 03       	and    $0x3ff,%cx
 454:	0f b7 c9             	movzwl %cx,%ecx
 457:	89 ce                	mov    %ecx,%esi
 459:	c1 e6 16             	shl    $0x16,%esi
 45c:	8b 4d a4             	mov    -0x5c(%ebp),%ecx
 45f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
 462:	8b 0c d9             	mov    (%ecx,%ebx,8),%ecx
 465:	c1 e9 0a             	shr    $0xa,%ecx
 468:	66 81 e1 ff 03       	and    $0x3ff,%cx
 46d:	0f b7 c9             	movzwl %cx,%ecx
 470:	c1 e1 0c             	shl    $0xc,%ecx
 473:	89 f3                	mov    %esi,%ebx
 475:	09 cb                	or     %ecx,%ebx
 477:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 47a:	01 d9                	add    %ebx,%ecx
 47c:	83 ec 0c             	sub    $0xc,%esp
 47f:	52                   	push   %edx
 480:	50                   	push   %eax
 481:	51                   	push   %ecx
 482:	68 b0 0d 00 00       	push   $0xdb0
 487:	6a 01                	push   $0x1
 489:	e8 54 04 00 00       	call   8e2 <printf>
 48e:	83 c4 20             	add    $0x20,%esp
                    exit();
 491:	e8 b8 02 00 00       	call   74e <exit>
          for (int j = 0; j < PGSIZE; j++) {
 496:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 49a:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
 4a1:	0f 8e 75 ff ff ff    	jle    41c <main+0x3be>
      for (int i = 0; i < retval; i++) {
 4a7:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
 4ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
 4ae:	3b 45 90             	cmp    -0x70(%ebp),%eax
 4b1:	0f 8c 96 fe ff ff    	jl     34d <main+0x2ef>
 4b7:	eb 15                	jmp    4ce <main+0x470>
              }
          }

      }
    } else
        printf(1, "XV6_TEST_OUTPUT: getpgtable returned incorrect value: expected %d, got %d\n", heap_pages_num, retval);
 4b9:	ff 75 90             	pushl  -0x70(%ebp)
 4bc:	ff 75 9c             	pushl  -0x64(%ebp)
 4bf:	68 00 0e 00 00       	push   $0xe00
 4c4:	6a 01                	push   $0x1
 4c6:	e8 17 04 00 00       	call   8e2 <printf>
 4cb:	83 c4 10             	add    $0x10,%esp
    
    exit();
 4ce:	e8 7b 02 00 00       	call   74e <exit>

000004d3 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 4d3:	55                   	push   %ebp
 4d4:	89 e5                	mov    %esp,%ebp
 4d6:	57                   	push   %edi
 4d7:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 4d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4db:	8b 55 10             	mov    0x10(%ebp),%edx
 4de:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e1:	89 cb                	mov    %ecx,%ebx
 4e3:	89 df                	mov    %ebx,%edi
 4e5:	89 d1                	mov    %edx,%ecx
 4e7:	fc                   	cld    
 4e8:	f3 aa                	rep stos %al,%es:(%edi)
 4ea:	89 ca                	mov    %ecx,%edx
 4ec:	89 fb                	mov    %edi,%ebx
 4ee:	89 5d 08             	mov    %ebx,0x8(%ebp)
 4f1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 4f4:	90                   	nop
 4f5:	5b                   	pop    %ebx
 4f6:	5f                   	pop    %edi
 4f7:	5d                   	pop    %ebp
 4f8:	c3                   	ret    

000004f9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 4f9:	f3 0f 1e fb          	endbr32 
 4fd:	55                   	push   %ebp
 4fe:	89 e5                	mov    %esp,%ebp
 500:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 503:	8b 45 08             	mov    0x8(%ebp),%eax
 506:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 509:	90                   	nop
 50a:	8b 55 0c             	mov    0xc(%ebp),%edx
 50d:	8d 42 01             	lea    0x1(%edx),%eax
 510:	89 45 0c             	mov    %eax,0xc(%ebp)
 513:	8b 45 08             	mov    0x8(%ebp),%eax
 516:	8d 48 01             	lea    0x1(%eax),%ecx
 519:	89 4d 08             	mov    %ecx,0x8(%ebp)
 51c:	0f b6 12             	movzbl (%edx),%edx
 51f:	88 10                	mov    %dl,(%eax)
 521:	0f b6 00             	movzbl (%eax),%eax
 524:	84 c0                	test   %al,%al
 526:	75 e2                	jne    50a <strcpy+0x11>
    ;
  return os;
 528:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 52b:	c9                   	leave  
 52c:	c3                   	ret    

0000052d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 52d:	f3 0f 1e fb          	endbr32 
 531:	55                   	push   %ebp
 532:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 534:	eb 08                	jmp    53e <strcmp+0x11>
    p++, q++;
 536:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 53a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 53e:	8b 45 08             	mov    0x8(%ebp),%eax
 541:	0f b6 00             	movzbl (%eax),%eax
 544:	84 c0                	test   %al,%al
 546:	74 10                	je     558 <strcmp+0x2b>
 548:	8b 45 08             	mov    0x8(%ebp),%eax
 54b:	0f b6 10             	movzbl (%eax),%edx
 54e:	8b 45 0c             	mov    0xc(%ebp),%eax
 551:	0f b6 00             	movzbl (%eax),%eax
 554:	38 c2                	cmp    %al,%dl
 556:	74 de                	je     536 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 558:	8b 45 08             	mov    0x8(%ebp),%eax
 55b:	0f b6 00             	movzbl (%eax),%eax
 55e:	0f b6 d0             	movzbl %al,%edx
 561:	8b 45 0c             	mov    0xc(%ebp),%eax
 564:	0f b6 00             	movzbl (%eax),%eax
 567:	0f b6 c0             	movzbl %al,%eax
 56a:	29 c2                	sub    %eax,%edx
 56c:	89 d0                	mov    %edx,%eax
}
 56e:	5d                   	pop    %ebp
 56f:	c3                   	ret    

00000570 <strlen>:

uint
strlen(const char *s)
{
 570:	f3 0f 1e fb          	endbr32 
 574:	55                   	push   %ebp
 575:	89 e5                	mov    %esp,%ebp
 577:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 57a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 581:	eb 04                	jmp    587 <strlen+0x17>
 583:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 587:	8b 55 fc             	mov    -0x4(%ebp),%edx
 58a:	8b 45 08             	mov    0x8(%ebp),%eax
 58d:	01 d0                	add    %edx,%eax
 58f:	0f b6 00             	movzbl (%eax),%eax
 592:	84 c0                	test   %al,%al
 594:	75 ed                	jne    583 <strlen+0x13>
    ;
  return n;
 596:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 599:	c9                   	leave  
 59a:	c3                   	ret    

0000059b <memset>:

void*
memset(void *dst, int c, uint n)
{
 59b:	f3 0f 1e fb          	endbr32 
 59f:	55                   	push   %ebp
 5a0:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 5a2:	8b 45 10             	mov    0x10(%ebp),%eax
 5a5:	50                   	push   %eax
 5a6:	ff 75 0c             	pushl  0xc(%ebp)
 5a9:	ff 75 08             	pushl  0x8(%ebp)
 5ac:	e8 22 ff ff ff       	call   4d3 <stosb>
 5b1:	83 c4 0c             	add    $0xc,%esp
  return dst;
 5b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5b7:	c9                   	leave  
 5b8:	c3                   	ret    

000005b9 <strchr>:

char*
strchr(const char *s, char c)
{
 5b9:	f3 0f 1e fb          	endbr32 
 5bd:	55                   	push   %ebp
 5be:	89 e5                	mov    %esp,%ebp
 5c0:	83 ec 04             	sub    $0x4,%esp
 5c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c6:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 5c9:	eb 14                	jmp    5df <strchr+0x26>
    if(*s == c)
 5cb:	8b 45 08             	mov    0x8(%ebp),%eax
 5ce:	0f b6 00             	movzbl (%eax),%eax
 5d1:	38 45 fc             	cmp    %al,-0x4(%ebp)
 5d4:	75 05                	jne    5db <strchr+0x22>
      return (char*)s;
 5d6:	8b 45 08             	mov    0x8(%ebp),%eax
 5d9:	eb 13                	jmp    5ee <strchr+0x35>
  for(; *s; s++)
 5db:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 5df:	8b 45 08             	mov    0x8(%ebp),%eax
 5e2:	0f b6 00             	movzbl (%eax),%eax
 5e5:	84 c0                	test   %al,%al
 5e7:	75 e2                	jne    5cb <strchr+0x12>
  return 0;
 5e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
 5ee:	c9                   	leave  
 5ef:	c3                   	ret    

000005f0 <gets>:

char*
gets(char *buf, int max)
{
 5f0:	f3 0f 1e fb          	endbr32 
 5f4:	55                   	push   %ebp
 5f5:	89 e5                	mov    %esp,%ebp
 5f7:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 601:	eb 42                	jmp    645 <gets+0x55>
    cc = read(0, &c, 1);
 603:	83 ec 04             	sub    $0x4,%esp
 606:	6a 01                	push   $0x1
 608:	8d 45 ef             	lea    -0x11(%ebp),%eax
 60b:	50                   	push   %eax
 60c:	6a 00                	push   $0x0
 60e:	e8 53 01 00 00       	call   766 <read>
 613:	83 c4 10             	add    $0x10,%esp
 616:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 619:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 61d:	7e 33                	jle    652 <gets+0x62>
      break;
    buf[i++] = c;
 61f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 622:	8d 50 01             	lea    0x1(%eax),%edx
 625:	89 55 f4             	mov    %edx,-0xc(%ebp)
 628:	89 c2                	mov    %eax,%edx
 62a:	8b 45 08             	mov    0x8(%ebp),%eax
 62d:	01 c2                	add    %eax,%edx
 62f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 633:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 635:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 639:	3c 0a                	cmp    $0xa,%al
 63b:	74 16                	je     653 <gets+0x63>
 63d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 641:	3c 0d                	cmp    $0xd,%al
 643:	74 0e                	je     653 <gets+0x63>
  for(i=0; i+1 < max; ){
 645:	8b 45 f4             	mov    -0xc(%ebp),%eax
 648:	83 c0 01             	add    $0x1,%eax
 64b:	39 45 0c             	cmp    %eax,0xc(%ebp)
 64e:	7f b3                	jg     603 <gets+0x13>
 650:	eb 01                	jmp    653 <gets+0x63>
      break;
 652:	90                   	nop
      break;
  }
  buf[i] = '\0';
 653:	8b 55 f4             	mov    -0xc(%ebp),%edx
 656:	8b 45 08             	mov    0x8(%ebp),%eax
 659:	01 d0                	add    %edx,%eax
 65b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 65e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 661:	c9                   	leave  
 662:	c3                   	ret    

00000663 <stat>:

int
stat(const char *n, struct stat *st)
{
 663:	f3 0f 1e fb          	endbr32 
 667:	55                   	push   %ebp
 668:	89 e5                	mov    %esp,%ebp
 66a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 66d:	83 ec 08             	sub    $0x8,%esp
 670:	6a 00                	push   $0x0
 672:	ff 75 08             	pushl  0x8(%ebp)
 675:	e8 14 01 00 00       	call   78e <open>
 67a:	83 c4 10             	add    $0x10,%esp
 67d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 680:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 684:	79 07                	jns    68d <stat+0x2a>
    return -1;
 686:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 68b:	eb 25                	jmp    6b2 <stat+0x4f>
  r = fstat(fd, st);
 68d:	83 ec 08             	sub    $0x8,%esp
 690:	ff 75 0c             	pushl  0xc(%ebp)
 693:	ff 75 f4             	pushl  -0xc(%ebp)
 696:	e8 0b 01 00 00       	call   7a6 <fstat>
 69b:	83 c4 10             	add    $0x10,%esp
 69e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 6a1:	83 ec 0c             	sub    $0xc,%esp
 6a4:	ff 75 f4             	pushl  -0xc(%ebp)
 6a7:	e8 ca 00 00 00       	call   776 <close>
 6ac:	83 c4 10             	add    $0x10,%esp
  return r;
 6af:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 6b2:	c9                   	leave  
 6b3:	c3                   	ret    

000006b4 <atoi>:

int
atoi(const char *s)
{
 6b4:	f3 0f 1e fb          	endbr32 
 6b8:	55                   	push   %ebp
 6b9:	89 e5                	mov    %esp,%ebp
 6bb:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 6be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 6c5:	eb 25                	jmp    6ec <atoi+0x38>
    n = n*10 + *s++ - '0';
 6c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6ca:	89 d0                	mov    %edx,%eax
 6cc:	c1 e0 02             	shl    $0x2,%eax
 6cf:	01 d0                	add    %edx,%eax
 6d1:	01 c0                	add    %eax,%eax
 6d3:	89 c1                	mov    %eax,%ecx
 6d5:	8b 45 08             	mov    0x8(%ebp),%eax
 6d8:	8d 50 01             	lea    0x1(%eax),%edx
 6db:	89 55 08             	mov    %edx,0x8(%ebp)
 6de:	0f b6 00             	movzbl (%eax),%eax
 6e1:	0f be c0             	movsbl %al,%eax
 6e4:	01 c8                	add    %ecx,%eax
 6e6:	83 e8 30             	sub    $0x30,%eax
 6e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 6ec:	8b 45 08             	mov    0x8(%ebp),%eax
 6ef:	0f b6 00             	movzbl (%eax),%eax
 6f2:	3c 2f                	cmp    $0x2f,%al
 6f4:	7e 0a                	jle    700 <atoi+0x4c>
 6f6:	8b 45 08             	mov    0x8(%ebp),%eax
 6f9:	0f b6 00             	movzbl (%eax),%eax
 6fc:	3c 39                	cmp    $0x39,%al
 6fe:	7e c7                	jle    6c7 <atoi+0x13>
  return n;
 700:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 703:	c9                   	leave  
 704:	c3                   	ret    

00000705 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 705:	f3 0f 1e fb          	endbr32 
 709:	55                   	push   %ebp
 70a:	89 e5                	mov    %esp,%ebp
 70c:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 70f:	8b 45 08             	mov    0x8(%ebp),%eax
 712:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 715:	8b 45 0c             	mov    0xc(%ebp),%eax
 718:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 71b:	eb 17                	jmp    734 <memmove+0x2f>
    *dst++ = *src++;
 71d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 720:	8d 42 01             	lea    0x1(%edx),%eax
 723:	89 45 f8             	mov    %eax,-0x8(%ebp)
 726:	8b 45 fc             	mov    -0x4(%ebp),%eax
 729:	8d 48 01             	lea    0x1(%eax),%ecx
 72c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 72f:	0f b6 12             	movzbl (%edx),%edx
 732:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 734:	8b 45 10             	mov    0x10(%ebp),%eax
 737:	8d 50 ff             	lea    -0x1(%eax),%edx
 73a:	89 55 10             	mov    %edx,0x10(%ebp)
 73d:	85 c0                	test   %eax,%eax
 73f:	7f dc                	jg     71d <memmove+0x18>
  return vdst;
 741:	8b 45 08             	mov    0x8(%ebp),%eax
}
 744:	c9                   	leave  
 745:	c3                   	ret    

00000746 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 746:	b8 01 00 00 00       	mov    $0x1,%eax
 74b:	cd 40                	int    $0x40
 74d:	c3                   	ret    

0000074e <exit>:
SYSCALL(exit)
 74e:	b8 02 00 00 00       	mov    $0x2,%eax
 753:	cd 40                	int    $0x40
 755:	c3                   	ret    

00000756 <wait>:
SYSCALL(wait)
 756:	b8 03 00 00 00       	mov    $0x3,%eax
 75b:	cd 40                	int    $0x40
 75d:	c3                   	ret    

0000075e <pipe>:
SYSCALL(pipe)
 75e:	b8 04 00 00 00       	mov    $0x4,%eax
 763:	cd 40                	int    $0x40
 765:	c3                   	ret    

00000766 <read>:
SYSCALL(read)
 766:	b8 05 00 00 00       	mov    $0x5,%eax
 76b:	cd 40                	int    $0x40
 76d:	c3                   	ret    

0000076e <write>:
SYSCALL(write)
 76e:	b8 10 00 00 00       	mov    $0x10,%eax
 773:	cd 40                	int    $0x40
 775:	c3                   	ret    

00000776 <close>:
SYSCALL(close)
 776:	b8 15 00 00 00       	mov    $0x15,%eax
 77b:	cd 40                	int    $0x40
 77d:	c3                   	ret    

0000077e <kill>:
SYSCALL(kill)
 77e:	b8 06 00 00 00       	mov    $0x6,%eax
 783:	cd 40                	int    $0x40
 785:	c3                   	ret    

00000786 <exec>:
SYSCALL(exec)
 786:	b8 07 00 00 00       	mov    $0x7,%eax
 78b:	cd 40                	int    $0x40
 78d:	c3                   	ret    

0000078e <open>:
SYSCALL(open)
 78e:	b8 0f 00 00 00       	mov    $0xf,%eax
 793:	cd 40                	int    $0x40
 795:	c3                   	ret    

00000796 <mknod>:
SYSCALL(mknod)
 796:	b8 11 00 00 00       	mov    $0x11,%eax
 79b:	cd 40                	int    $0x40
 79d:	c3                   	ret    

0000079e <unlink>:
SYSCALL(unlink)
 79e:	b8 12 00 00 00       	mov    $0x12,%eax
 7a3:	cd 40                	int    $0x40
 7a5:	c3                   	ret    

000007a6 <fstat>:
SYSCALL(fstat)
 7a6:	b8 08 00 00 00       	mov    $0x8,%eax
 7ab:	cd 40                	int    $0x40
 7ad:	c3                   	ret    

000007ae <link>:
SYSCALL(link)
 7ae:	b8 13 00 00 00       	mov    $0x13,%eax
 7b3:	cd 40                	int    $0x40
 7b5:	c3                   	ret    

000007b6 <mkdir>:
SYSCALL(mkdir)
 7b6:	b8 14 00 00 00       	mov    $0x14,%eax
 7bb:	cd 40                	int    $0x40
 7bd:	c3                   	ret    

000007be <chdir>:
SYSCALL(chdir)
 7be:	b8 09 00 00 00       	mov    $0x9,%eax
 7c3:	cd 40                	int    $0x40
 7c5:	c3                   	ret    

000007c6 <dup>:
SYSCALL(dup)
 7c6:	b8 0a 00 00 00       	mov    $0xa,%eax
 7cb:	cd 40                	int    $0x40
 7cd:	c3                   	ret    

000007ce <getpid>:
SYSCALL(getpid)
 7ce:	b8 0b 00 00 00       	mov    $0xb,%eax
 7d3:	cd 40                	int    $0x40
 7d5:	c3                   	ret    

000007d6 <sbrk>:
SYSCALL(sbrk)
 7d6:	b8 0c 00 00 00       	mov    $0xc,%eax
 7db:	cd 40                	int    $0x40
 7dd:	c3                   	ret    

000007de <sleep>:
SYSCALL(sleep)
 7de:	b8 0d 00 00 00       	mov    $0xd,%eax
 7e3:	cd 40                	int    $0x40
 7e5:	c3                   	ret    

000007e6 <uptime>:
SYSCALL(uptime)
 7e6:	b8 0e 00 00 00       	mov    $0xe,%eax
 7eb:	cd 40                	int    $0x40
 7ed:	c3                   	ret    

000007ee <mencrypt>:
SYSCALL(mencrypt)
 7ee:	b8 16 00 00 00       	mov    $0x16,%eax
 7f3:	cd 40                	int    $0x40
 7f5:	c3                   	ret    

000007f6 <getpgtable>:
SYSCALL(getpgtable)
 7f6:	b8 17 00 00 00       	mov    $0x17,%eax
 7fb:	cd 40                	int    $0x40
 7fd:	c3                   	ret    

000007fe <dump_rawphymem>:
SYSCALL(dump_rawphymem)
 7fe:	b8 18 00 00 00       	mov    $0x18,%eax
 803:	cd 40                	int    $0x40
 805:	c3                   	ret    

00000806 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 806:	f3 0f 1e fb          	endbr32 
 80a:	55                   	push   %ebp
 80b:	89 e5                	mov    %esp,%ebp
 80d:	83 ec 18             	sub    $0x18,%esp
 810:	8b 45 0c             	mov    0xc(%ebp),%eax
 813:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 816:	83 ec 04             	sub    $0x4,%esp
 819:	6a 01                	push   $0x1
 81b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 81e:	50                   	push   %eax
 81f:	ff 75 08             	pushl  0x8(%ebp)
 822:	e8 47 ff ff ff       	call   76e <write>
 827:	83 c4 10             	add    $0x10,%esp
}
 82a:	90                   	nop
 82b:	c9                   	leave  
 82c:	c3                   	ret    

0000082d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 82d:	f3 0f 1e fb          	endbr32 
 831:	55                   	push   %ebp
 832:	89 e5                	mov    %esp,%ebp
 834:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 837:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 83e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 842:	74 17                	je     85b <printint+0x2e>
 844:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 848:	79 11                	jns    85b <printint+0x2e>
    neg = 1;
 84a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 851:	8b 45 0c             	mov    0xc(%ebp),%eax
 854:	f7 d8                	neg    %eax
 856:	89 45 ec             	mov    %eax,-0x14(%ebp)
 859:	eb 06                	jmp    861 <printint+0x34>
  } else {
    x = xx;
 85b:	8b 45 0c             	mov    0xc(%ebp),%eax
 85e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 861:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 868:	8b 4d 10             	mov    0x10(%ebp),%ecx
 86b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 86e:	ba 00 00 00 00       	mov    $0x0,%edx
 873:	f7 f1                	div    %ecx
 875:	89 d1                	mov    %edx,%ecx
 877:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87a:	8d 50 01             	lea    0x1(%eax),%edx
 87d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 880:	0f b6 91 e0 10 00 00 	movzbl 0x10e0(%ecx),%edx
 887:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 88b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 88e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 891:	ba 00 00 00 00       	mov    $0x0,%edx
 896:	f7 f1                	div    %ecx
 898:	89 45 ec             	mov    %eax,-0x14(%ebp)
 89b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 89f:	75 c7                	jne    868 <printint+0x3b>
  if(neg)
 8a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8a5:	74 2d                	je     8d4 <printint+0xa7>
    buf[i++] = '-';
 8a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8aa:	8d 50 01             	lea    0x1(%eax),%edx
 8ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8b0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 8b5:	eb 1d                	jmp    8d4 <printint+0xa7>
    putc(fd, buf[i]);
 8b7:	8d 55 dc             	lea    -0x24(%ebp),%edx
 8ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bd:	01 d0                	add    %edx,%eax
 8bf:	0f b6 00             	movzbl (%eax),%eax
 8c2:	0f be c0             	movsbl %al,%eax
 8c5:	83 ec 08             	sub    $0x8,%esp
 8c8:	50                   	push   %eax
 8c9:	ff 75 08             	pushl  0x8(%ebp)
 8cc:	e8 35 ff ff ff       	call   806 <putc>
 8d1:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 8d4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 8d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8dc:	79 d9                	jns    8b7 <printint+0x8a>
}
 8de:	90                   	nop
 8df:	90                   	nop
 8e0:	c9                   	leave  
 8e1:	c3                   	ret    

000008e2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 8e2:	f3 0f 1e fb          	endbr32 
 8e6:	55                   	push   %ebp
 8e7:	89 e5                	mov    %esp,%ebp
 8e9:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 8ec:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 8f3:	8d 45 0c             	lea    0xc(%ebp),%eax
 8f6:	83 c0 04             	add    $0x4,%eax
 8f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 8fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 903:	e9 59 01 00 00       	jmp    a61 <printf+0x17f>
    c = fmt[i] & 0xff;
 908:	8b 55 0c             	mov    0xc(%ebp),%edx
 90b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90e:	01 d0                	add    %edx,%eax
 910:	0f b6 00             	movzbl (%eax),%eax
 913:	0f be c0             	movsbl %al,%eax
 916:	25 ff 00 00 00       	and    $0xff,%eax
 91b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 91e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 922:	75 2c                	jne    950 <printf+0x6e>
      if(c == '%'){
 924:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 928:	75 0c                	jne    936 <printf+0x54>
        state = '%';
 92a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 931:	e9 27 01 00 00       	jmp    a5d <printf+0x17b>
      } else {
        putc(fd, c);
 936:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 939:	0f be c0             	movsbl %al,%eax
 93c:	83 ec 08             	sub    $0x8,%esp
 93f:	50                   	push   %eax
 940:	ff 75 08             	pushl  0x8(%ebp)
 943:	e8 be fe ff ff       	call   806 <putc>
 948:	83 c4 10             	add    $0x10,%esp
 94b:	e9 0d 01 00 00       	jmp    a5d <printf+0x17b>
      }
    } else if(state == '%'){
 950:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 954:	0f 85 03 01 00 00    	jne    a5d <printf+0x17b>
      if(c == 'd'){
 95a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 95e:	75 1e                	jne    97e <printf+0x9c>
        printint(fd, *ap, 10, 1);
 960:	8b 45 e8             	mov    -0x18(%ebp),%eax
 963:	8b 00                	mov    (%eax),%eax
 965:	6a 01                	push   $0x1
 967:	6a 0a                	push   $0xa
 969:	50                   	push   %eax
 96a:	ff 75 08             	pushl  0x8(%ebp)
 96d:	e8 bb fe ff ff       	call   82d <printint>
 972:	83 c4 10             	add    $0x10,%esp
        ap++;
 975:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 979:	e9 d8 00 00 00       	jmp    a56 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 97e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 982:	74 06                	je     98a <printf+0xa8>
 984:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 988:	75 1e                	jne    9a8 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 98a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 98d:	8b 00                	mov    (%eax),%eax
 98f:	6a 00                	push   $0x0
 991:	6a 10                	push   $0x10
 993:	50                   	push   %eax
 994:	ff 75 08             	pushl  0x8(%ebp)
 997:	e8 91 fe ff ff       	call   82d <printint>
 99c:	83 c4 10             	add    $0x10,%esp
        ap++;
 99f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9a3:	e9 ae 00 00 00       	jmp    a56 <printf+0x174>
      } else if(c == 's'){
 9a8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 9ac:	75 43                	jne    9f1 <printf+0x10f>
        s = (char*)*ap;
 9ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9b1:	8b 00                	mov    (%eax),%eax
 9b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 9b6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 9ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9be:	75 25                	jne    9e5 <printf+0x103>
          s = "(null)";
 9c0:	c7 45 f4 4b 0e 00 00 	movl   $0xe4b,-0xc(%ebp)
        while(*s != 0){
 9c7:	eb 1c                	jmp    9e5 <printf+0x103>
          putc(fd, *s);
 9c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cc:	0f b6 00             	movzbl (%eax),%eax
 9cf:	0f be c0             	movsbl %al,%eax
 9d2:	83 ec 08             	sub    $0x8,%esp
 9d5:	50                   	push   %eax
 9d6:	ff 75 08             	pushl  0x8(%ebp)
 9d9:	e8 28 fe ff ff       	call   806 <putc>
 9de:	83 c4 10             	add    $0x10,%esp
          s++;
 9e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 9e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e8:	0f b6 00             	movzbl (%eax),%eax
 9eb:	84 c0                	test   %al,%al
 9ed:	75 da                	jne    9c9 <printf+0xe7>
 9ef:	eb 65                	jmp    a56 <printf+0x174>
        }
      } else if(c == 'c'){
 9f1:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 9f5:	75 1d                	jne    a14 <printf+0x132>
        putc(fd, *ap);
 9f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9fa:	8b 00                	mov    (%eax),%eax
 9fc:	0f be c0             	movsbl %al,%eax
 9ff:	83 ec 08             	sub    $0x8,%esp
 a02:	50                   	push   %eax
 a03:	ff 75 08             	pushl  0x8(%ebp)
 a06:	e8 fb fd ff ff       	call   806 <putc>
 a0b:	83 c4 10             	add    $0x10,%esp
        ap++;
 a0e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a12:	eb 42                	jmp    a56 <printf+0x174>
      } else if(c == '%'){
 a14:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a18:	75 17                	jne    a31 <printf+0x14f>
        putc(fd, c);
 a1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a1d:	0f be c0             	movsbl %al,%eax
 a20:	83 ec 08             	sub    $0x8,%esp
 a23:	50                   	push   %eax
 a24:	ff 75 08             	pushl  0x8(%ebp)
 a27:	e8 da fd ff ff       	call   806 <putc>
 a2c:	83 c4 10             	add    $0x10,%esp
 a2f:	eb 25                	jmp    a56 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a31:	83 ec 08             	sub    $0x8,%esp
 a34:	6a 25                	push   $0x25
 a36:	ff 75 08             	pushl  0x8(%ebp)
 a39:	e8 c8 fd ff ff       	call   806 <putc>
 a3e:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 a41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a44:	0f be c0             	movsbl %al,%eax
 a47:	83 ec 08             	sub    $0x8,%esp
 a4a:	50                   	push   %eax
 a4b:	ff 75 08             	pushl  0x8(%ebp)
 a4e:	e8 b3 fd ff ff       	call   806 <putc>
 a53:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 a56:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 a5d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 a61:	8b 55 0c             	mov    0xc(%ebp),%edx
 a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a67:	01 d0                	add    %edx,%eax
 a69:	0f b6 00             	movzbl (%eax),%eax
 a6c:	84 c0                	test   %al,%al
 a6e:	0f 85 94 fe ff ff    	jne    908 <printf+0x26>
    }
  }
}
 a74:	90                   	nop
 a75:	90                   	nop
 a76:	c9                   	leave  
 a77:	c3                   	ret    

00000a78 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a78:	f3 0f 1e fb          	endbr32 
 a7c:	55                   	push   %ebp
 a7d:	89 e5                	mov    %esp,%ebp
 a7f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a82:	8b 45 08             	mov    0x8(%ebp),%eax
 a85:	83 e8 08             	sub    $0x8,%eax
 a88:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a8b:	a1 fc 10 00 00       	mov    0x10fc,%eax
 a90:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a93:	eb 24                	jmp    ab9 <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a95:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a98:	8b 00                	mov    (%eax),%eax
 a9a:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 a9d:	72 12                	jb     ab1 <free+0x39>
 a9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aa2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 aa5:	77 24                	ja     acb <free+0x53>
 aa7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aaa:	8b 00                	mov    (%eax),%eax
 aac:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 aaf:	72 1a                	jb     acb <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ab1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab4:	8b 00                	mov    (%eax),%eax
 ab6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 ab9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 abc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 abf:	76 d4                	jbe    a95 <free+0x1d>
 ac1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac4:	8b 00                	mov    (%eax),%eax
 ac6:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 ac9:	73 ca                	jae    a95 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 acb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ace:	8b 40 04             	mov    0x4(%eax),%eax
 ad1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ad8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 adb:	01 c2                	add    %eax,%edx
 add:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ae0:	8b 00                	mov    (%eax),%eax
 ae2:	39 c2                	cmp    %eax,%edx
 ae4:	75 24                	jne    b0a <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 ae6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ae9:	8b 50 04             	mov    0x4(%eax),%edx
 aec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aef:	8b 00                	mov    (%eax),%eax
 af1:	8b 40 04             	mov    0x4(%eax),%eax
 af4:	01 c2                	add    %eax,%edx
 af6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 af9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 afc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aff:	8b 00                	mov    (%eax),%eax
 b01:	8b 10                	mov    (%eax),%edx
 b03:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b06:	89 10                	mov    %edx,(%eax)
 b08:	eb 0a                	jmp    b14 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 b0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b0d:	8b 10                	mov    (%eax),%edx
 b0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b12:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 b14:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b17:	8b 40 04             	mov    0x4(%eax),%eax
 b1a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b21:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b24:	01 d0                	add    %edx,%eax
 b26:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 b29:	75 20                	jne    b4b <free+0xd3>
    p->s.size += bp->s.size;
 b2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b2e:	8b 50 04             	mov    0x4(%eax),%edx
 b31:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b34:	8b 40 04             	mov    0x4(%eax),%eax
 b37:	01 c2                	add    %eax,%edx
 b39:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b3c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b42:	8b 10                	mov    (%eax),%edx
 b44:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b47:	89 10                	mov    %edx,(%eax)
 b49:	eb 08                	jmp    b53 <free+0xdb>
  } else
    p->s.ptr = bp;
 b4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b4e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 b51:	89 10                	mov    %edx,(%eax)
  freep = p;
 b53:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b56:	a3 fc 10 00 00       	mov    %eax,0x10fc
}
 b5b:	90                   	nop
 b5c:	c9                   	leave  
 b5d:	c3                   	ret    

00000b5e <morecore>:

static Header*
morecore(uint nu)
{
 b5e:	f3 0f 1e fb          	endbr32 
 b62:	55                   	push   %ebp
 b63:	89 e5                	mov    %esp,%ebp
 b65:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b68:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b6f:	77 07                	ja     b78 <morecore+0x1a>
    nu = 4096;
 b71:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b78:	8b 45 08             	mov    0x8(%ebp),%eax
 b7b:	c1 e0 03             	shl    $0x3,%eax
 b7e:	83 ec 0c             	sub    $0xc,%esp
 b81:	50                   	push   %eax
 b82:	e8 4f fc ff ff       	call   7d6 <sbrk>
 b87:	83 c4 10             	add    $0x10,%esp
 b8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b8d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b91:	75 07                	jne    b9a <morecore+0x3c>
    return 0;
 b93:	b8 00 00 00 00       	mov    $0x0,%eax
 b98:	eb 26                	jmp    bc0 <morecore+0x62>
  hp = (Header*)p;
 b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ba3:	8b 55 08             	mov    0x8(%ebp),%edx
 ba6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bac:	83 c0 08             	add    $0x8,%eax
 baf:	83 ec 0c             	sub    $0xc,%esp
 bb2:	50                   	push   %eax
 bb3:	e8 c0 fe ff ff       	call   a78 <free>
 bb8:	83 c4 10             	add    $0x10,%esp
  return freep;
 bbb:	a1 fc 10 00 00       	mov    0x10fc,%eax
}
 bc0:	c9                   	leave  
 bc1:	c3                   	ret    

00000bc2 <malloc>:

void*
malloc(uint nbytes)
{
 bc2:	f3 0f 1e fb          	endbr32 
 bc6:	55                   	push   %ebp
 bc7:	89 e5                	mov    %esp,%ebp
 bc9:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bcc:	8b 45 08             	mov    0x8(%ebp),%eax
 bcf:	83 c0 07             	add    $0x7,%eax
 bd2:	c1 e8 03             	shr    $0x3,%eax
 bd5:	83 c0 01             	add    $0x1,%eax
 bd8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 bdb:	a1 fc 10 00 00       	mov    0x10fc,%eax
 be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 be3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 be7:	75 23                	jne    c0c <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 be9:	c7 45 f0 f4 10 00 00 	movl   $0x10f4,-0x10(%ebp)
 bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bf3:	a3 fc 10 00 00       	mov    %eax,0x10fc
 bf8:	a1 fc 10 00 00       	mov    0x10fc,%eax
 bfd:	a3 f4 10 00 00       	mov    %eax,0x10f4
    base.s.size = 0;
 c02:	c7 05 f8 10 00 00 00 	movl   $0x0,0x10f8
 c09:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c0f:	8b 00                	mov    (%eax),%eax
 c11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c17:	8b 40 04             	mov    0x4(%eax),%eax
 c1a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 c1d:	77 4d                	ja     c6c <malloc+0xaa>
      if(p->s.size == nunits)
 c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c22:	8b 40 04             	mov    0x4(%eax),%eax
 c25:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 c28:	75 0c                	jne    c36 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c2d:	8b 10                	mov    (%eax),%edx
 c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c32:	89 10                	mov    %edx,(%eax)
 c34:	eb 26                	jmp    c5c <malloc+0x9a>
      else {
        p->s.size -= nunits;
 c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c39:	8b 40 04             	mov    0x4(%eax),%eax
 c3c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 c3f:	89 c2                	mov    %eax,%edx
 c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c44:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c4a:	8b 40 04             	mov    0x4(%eax),%eax
 c4d:	c1 e0 03             	shl    $0x3,%eax
 c50:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c56:	8b 55 ec             	mov    -0x14(%ebp),%edx
 c59:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 c5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c5f:	a3 fc 10 00 00       	mov    %eax,0x10fc
      return (void*)(p + 1);
 c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c67:	83 c0 08             	add    $0x8,%eax
 c6a:	eb 3b                	jmp    ca7 <malloc+0xe5>
    }
    if(p == freep)
 c6c:	a1 fc 10 00 00       	mov    0x10fc,%eax
 c71:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c74:	75 1e                	jne    c94 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 c76:	83 ec 0c             	sub    $0xc,%esp
 c79:	ff 75 ec             	pushl  -0x14(%ebp)
 c7c:	e8 dd fe ff ff       	call   b5e <morecore>
 c81:	83 c4 10             	add    $0x10,%esp
 c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c8b:	75 07                	jne    c94 <malloc+0xd2>
        return 0;
 c8d:	b8 00 00 00 00       	mov    $0x0,%eax
 c92:	eb 13                	jmp    ca7 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c97:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c9d:	8b 00                	mov    (%eax),%eax
 c9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ca2:	e9 6d ff ff ff       	jmp    c14 <malloc+0x52>
  }
}
 ca7:	c9                   	leave  
 ca8:	c3                   	ret    
