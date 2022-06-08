
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 c0 10 00       	mov    $0x10c000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 e6 10 80       	mov    $0x8010e650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 3a 3a 10 80       	mov    $0x80103a3a,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	f3 0f 1e fb          	endbr32 
80100038:	55                   	push   %ebp
80100039:	89 e5                	mov    %esp,%ebp
8010003b:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003e:	83 ec 08             	sub    $0x8,%esp
80100041:	68 c8 97 10 80       	push   $0x801097c8
80100046:	68 60 e6 10 80       	push   $0x8010e660
8010004b:	e8 36 55 00 00       	call   80105586 <initlock>
80100050:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100053:	c7 05 ac 2d 11 80 5c 	movl   $0x80112d5c,0x80112dac
8010005a:	2d 11 80 
  bcache.head.next = &bcache.head;
8010005d:	c7 05 b0 2d 11 80 5c 	movl   $0x80112d5c,0x80112db0
80100064:	2d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100067:	c7 45 f4 94 e6 10 80 	movl   $0x8010e694,-0xc(%ebp)
8010006e:	eb 47                	jmp    801000b7 <binit+0x83>
    b->next = bcache.head.next;
80100070:	8b 15 b0 2d 11 80    	mov    0x80112db0,%edx
80100076:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100079:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
8010007c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007f:	c7 40 50 5c 2d 11 80 	movl   $0x80112d5c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100086:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100089:	83 c0 0c             	add    $0xc,%eax
8010008c:	83 ec 08             	sub    $0x8,%esp
8010008f:	68 cf 97 10 80       	push   $0x801097cf
80100094:	50                   	push   %eax
80100095:	e8 59 53 00 00       	call   801053f3 <initsleeplock>
8010009a:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
8010009d:	a1 b0 2d 11 80       	mov    0x80112db0,%eax
801000a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801000a5:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ab:	a3 b0 2d 11 80       	mov    %eax,0x80112db0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b0:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b7:	b8 5c 2d 11 80       	mov    $0x80112d5c,%eax
801000bc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000bf:	72 af                	jb     80100070 <binit+0x3c>
  }
}
801000c1:	90                   	nop
801000c2:	90                   	nop
801000c3:	c9                   	leave  
801000c4:	c3                   	ret    

801000c5 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000c5:	f3 0f 1e fb          	endbr32 
801000c9:	55                   	push   %ebp
801000ca:	89 e5                	mov    %esp,%ebp
801000cc:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000cf:	83 ec 0c             	sub    $0xc,%esp
801000d2:	68 60 e6 10 80       	push   $0x8010e660
801000d7:	e8 d0 54 00 00       	call   801055ac <acquire>
801000dc:	83 c4 10             	add    $0x10,%esp

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000df:	a1 b0 2d 11 80       	mov    0x80112db0,%eax
801000e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000e7:	eb 58                	jmp    80100141 <bget+0x7c>
    if(b->dev == dev && b->blockno == blockno){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 40 04             	mov    0x4(%eax),%eax
801000ef:	39 45 08             	cmp    %eax,0x8(%ebp)
801000f2:	75 44                	jne    80100138 <bget+0x73>
801000f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f7:	8b 40 08             	mov    0x8(%eax),%eax
801000fa:	39 45 0c             	cmp    %eax,0xc(%ebp)
801000fd:	75 39                	jne    80100138 <bget+0x73>
      b->refcnt++;
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	8b 40 4c             	mov    0x4c(%eax),%eax
80100105:	8d 50 01             	lea    0x1(%eax),%edx
80100108:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010b:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
8010010e:	83 ec 0c             	sub    $0xc,%esp
80100111:	68 60 e6 10 80       	push   $0x8010e660
80100116:	e8 03 55 00 00       	call   8010561e <release>
8010011b:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
8010011e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100121:	83 c0 0c             	add    $0xc,%eax
80100124:	83 ec 0c             	sub    $0xc,%esp
80100127:	50                   	push   %eax
80100128:	e8 06 53 00 00       	call   80105433 <acquiresleep>
8010012d:	83 c4 10             	add    $0x10,%esp
      return b;
80100130:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100133:	e9 9d 00 00 00       	jmp    801001d5 <bget+0x110>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100138:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010013b:	8b 40 54             	mov    0x54(%eax),%eax
8010013e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100141:	81 7d f4 5c 2d 11 80 	cmpl   $0x80112d5c,-0xc(%ebp)
80100148:	75 9f                	jne    801000e9 <bget+0x24>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
8010014a:	a1 ac 2d 11 80       	mov    0x80112dac,%eax
8010014f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100152:	eb 6b                	jmp    801001bf <bget+0xfa>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
80100154:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100157:	8b 40 4c             	mov    0x4c(%eax),%eax
8010015a:	85 c0                	test   %eax,%eax
8010015c:	75 58                	jne    801001b6 <bget+0xf1>
8010015e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100161:	8b 00                	mov    (%eax),%eax
80100163:	83 e0 04             	and    $0x4,%eax
80100166:	85 c0                	test   %eax,%eax
80100168:	75 4c                	jne    801001b6 <bget+0xf1>
      b->dev = dev;
8010016a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016d:	8b 55 08             	mov    0x8(%ebp),%edx
80100170:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
80100173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100176:	8b 55 0c             	mov    0xc(%ebp),%edx
80100179:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
8010017c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
80100185:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100188:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
8010018f:	83 ec 0c             	sub    $0xc,%esp
80100192:	68 60 e6 10 80       	push   $0x8010e660
80100197:	e8 82 54 00 00       	call   8010561e <release>
8010019c:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
8010019f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001a2:	83 c0 0c             	add    $0xc,%eax
801001a5:	83 ec 0c             	sub    $0xc,%esp
801001a8:	50                   	push   %eax
801001a9:	e8 85 52 00 00       	call   80105433 <acquiresleep>
801001ae:	83 c4 10             	add    $0x10,%esp
      return b;
801001b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001b4:	eb 1f                	jmp    801001d5 <bget+0x110>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801001b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001b9:	8b 40 50             	mov    0x50(%eax),%eax
801001bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001bf:	81 7d f4 5c 2d 11 80 	cmpl   $0x80112d5c,-0xc(%ebp)
801001c6:	75 8c                	jne    80100154 <bget+0x8f>
    }
  }
  panic("bget: no buffers");
801001c8:	83 ec 0c             	sub    $0xc,%esp
801001cb:	68 d6 97 10 80       	push   $0x801097d6
801001d0:	e8 33 04 00 00       	call   80100608 <panic>
}
801001d5:	c9                   	leave  
801001d6:	c3                   	ret    

801001d7 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001d7:	f3 0f 1e fb          	endbr32 
801001db:	55                   	push   %ebp
801001dc:	89 e5                	mov    %esp,%ebp
801001de:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001e1:	83 ec 08             	sub    $0x8,%esp
801001e4:	ff 75 0c             	pushl  0xc(%ebp)
801001e7:	ff 75 08             	pushl  0x8(%ebp)
801001ea:	e8 d6 fe ff ff       	call   801000c5 <bget>
801001ef:	83 c4 10             	add    $0x10,%esp
801001f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
801001f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 02             	and    $0x2,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0e                	jne    8010020f <bread+0x38>
    iderw(b);
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	ff 75 f4             	pushl  -0xc(%ebp)
80100207:	e8 b3 28 00 00       	call   80102abf <iderw>
8010020c:	83 c4 10             	add    $0x10,%esp
  }
  return b;
8010020f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80100212:	c9                   	leave  
80100213:	c3                   	ret    

80100214 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100214:	f3 0f 1e fb          	endbr32 
80100218:	55                   	push   %ebp
80100219:	89 e5                	mov    %esp,%ebp
8010021b:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
8010021e:	8b 45 08             	mov    0x8(%ebp),%eax
80100221:	83 c0 0c             	add    $0xc,%eax
80100224:	83 ec 0c             	sub    $0xc,%esp
80100227:	50                   	push   %eax
80100228:	e8 c0 52 00 00       	call   801054ed <holdingsleep>
8010022d:	83 c4 10             	add    $0x10,%esp
80100230:	85 c0                	test   %eax,%eax
80100232:	75 0d                	jne    80100241 <bwrite+0x2d>
    panic("bwrite");
80100234:	83 ec 0c             	sub    $0xc,%esp
80100237:	68 e7 97 10 80       	push   $0x801097e7
8010023c:	e8 c7 03 00 00       	call   80100608 <panic>
  b->flags |= B_DIRTY;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 00                	mov    (%eax),%eax
80100246:	83 c8 04             	or     $0x4,%eax
80100249:	89 c2                	mov    %eax,%edx
8010024b:	8b 45 08             	mov    0x8(%ebp),%eax
8010024e:	89 10                	mov    %edx,(%eax)
  iderw(b);
80100250:	83 ec 0c             	sub    $0xc,%esp
80100253:	ff 75 08             	pushl  0x8(%ebp)
80100256:	e8 64 28 00 00       	call   80102abf <iderw>
8010025b:	83 c4 10             	add    $0x10,%esp
}
8010025e:	90                   	nop
8010025f:	c9                   	leave  
80100260:	c3                   	ret    

80100261 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100261:	f3 0f 1e fb          	endbr32 
80100265:	55                   	push   %ebp
80100266:	89 e5                	mov    %esp,%ebp
80100268:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	83 c0 0c             	add    $0xc,%eax
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	50                   	push   %eax
80100275:	e8 73 52 00 00       	call   801054ed <holdingsleep>
8010027a:	83 c4 10             	add    $0x10,%esp
8010027d:	85 c0                	test   %eax,%eax
8010027f:	75 0d                	jne    8010028e <brelse+0x2d>
    panic("brelse");
80100281:	83 ec 0c             	sub    $0xc,%esp
80100284:	68 ee 97 10 80       	push   $0x801097ee
80100289:	e8 7a 03 00 00       	call   80100608 <panic>

  releasesleep(&b->lock);
8010028e:	8b 45 08             	mov    0x8(%ebp),%eax
80100291:	83 c0 0c             	add    $0xc,%eax
80100294:	83 ec 0c             	sub    $0xc,%esp
80100297:	50                   	push   %eax
80100298:	e8 fe 51 00 00       	call   8010549b <releasesleep>
8010029d:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
801002a0:	83 ec 0c             	sub    $0xc,%esp
801002a3:	68 60 e6 10 80       	push   $0x8010e660
801002a8:	e8 ff 52 00 00       	call   801055ac <acquire>
801002ad:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
801002b0:	8b 45 08             	mov    0x8(%ebp),%eax
801002b3:	8b 40 4c             	mov    0x4c(%eax),%eax
801002b6:	8d 50 ff             	lea    -0x1(%eax),%edx
801002b9:	8b 45 08             	mov    0x8(%ebp),%eax
801002bc:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
801002bf:	8b 45 08             	mov    0x8(%ebp),%eax
801002c2:	8b 40 4c             	mov    0x4c(%eax),%eax
801002c5:	85 c0                	test   %eax,%eax
801002c7:	75 47                	jne    80100310 <brelse+0xaf>
    // no one is waiting for it.
    b->next->prev = b->prev;
801002c9:	8b 45 08             	mov    0x8(%ebp),%eax
801002cc:	8b 40 54             	mov    0x54(%eax),%eax
801002cf:	8b 55 08             	mov    0x8(%ebp),%edx
801002d2:	8b 52 50             	mov    0x50(%edx),%edx
801002d5:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
801002d8:	8b 45 08             	mov    0x8(%ebp),%eax
801002db:	8b 40 50             	mov    0x50(%eax),%eax
801002de:	8b 55 08             	mov    0x8(%ebp),%edx
801002e1:	8b 52 54             	mov    0x54(%edx),%edx
801002e4:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
801002e7:	8b 15 b0 2d 11 80    	mov    0x80112db0,%edx
801002ed:	8b 45 08             	mov    0x8(%ebp),%eax
801002f0:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002f3:	8b 45 08             	mov    0x8(%ebp),%eax
801002f6:	c7 40 50 5c 2d 11 80 	movl   $0x80112d5c,0x50(%eax)
    bcache.head.next->prev = b;
801002fd:	a1 b0 2d 11 80       	mov    0x80112db0,%eax
80100302:	8b 55 08             	mov    0x8(%ebp),%edx
80100305:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
80100308:	8b 45 08             	mov    0x8(%ebp),%eax
8010030b:	a3 b0 2d 11 80       	mov    %eax,0x80112db0
  }
  
  release(&bcache.lock);
80100310:	83 ec 0c             	sub    $0xc,%esp
80100313:	68 60 e6 10 80       	push   $0x8010e660
80100318:	e8 01 53 00 00       	call   8010561e <release>
8010031d:	83 c4 10             	add    $0x10,%esp
}
80100320:	90                   	nop
80100321:	c9                   	leave  
80100322:	c3                   	ret    

80100323 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80100323:	55                   	push   %ebp
80100324:	89 e5                	mov    %esp,%ebp
80100326:	83 ec 14             	sub    $0x14,%esp
80100329:	8b 45 08             	mov    0x8(%ebp),%eax
8010032c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100330:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80100334:	89 c2                	mov    %eax,%edx
80100336:	ec                   	in     (%dx),%al
80100337:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010033a:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010033e:	c9                   	leave  
8010033f:	c3                   	ret    

80100340 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80100340:	55                   	push   %ebp
80100341:	89 e5                	mov    %esp,%ebp
80100343:	83 ec 08             	sub    $0x8,%esp
80100346:	8b 45 08             	mov    0x8(%ebp),%eax
80100349:	8b 55 0c             	mov    0xc(%ebp),%edx
8010034c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80100350:	89 d0                	mov    %edx,%eax
80100352:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100355:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100359:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010035d:	ee                   	out    %al,(%dx)
}
8010035e:	90                   	nop
8010035f:	c9                   	leave  
80100360:	c3                   	ret    

80100361 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100361:	55                   	push   %ebp
80100362:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100364:	fa                   	cli    
}
80100365:	90                   	nop
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    

80100368 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100368:	f3 0f 1e fb          	endbr32 
8010036c:	55                   	push   %ebp
8010036d:	89 e5                	mov    %esp,%ebp
8010036f:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100372:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100376:	74 1c                	je     80100394 <printint+0x2c>
80100378:	8b 45 08             	mov    0x8(%ebp),%eax
8010037b:	c1 e8 1f             	shr    $0x1f,%eax
8010037e:	0f b6 c0             	movzbl %al,%eax
80100381:	89 45 10             	mov    %eax,0x10(%ebp)
80100384:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100388:	74 0a                	je     80100394 <printint+0x2c>
    x = -xx;
8010038a:	8b 45 08             	mov    0x8(%ebp),%eax
8010038d:	f7 d8                	neg    %eax
8010038f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100392:	eb 06                	jmp    8010039a <printint+0x32>
  else
    x = xx;
80100394:	8b 45 08             	mov    0x8(%ebp),%eax
80100397:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
8010039a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
801003a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003a7:	ba 00 00 00 00       	mov    $0x0,%edx
801003ac:	f7 f1                	div    %ecx
801003ae:	89 d1                	mov    %edx,%ecx
801003b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003b3:	8d 50 01             	lea    0x1(%eax),%edx
801003b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003b9:	0f b6 91 04 b0 10 80 	movzbl -0x7fef4ffc(%ecx),%edx
801003c0:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  }while((x /= base) != 0);
801003c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801003c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003ca:	ba 00 00 00 00       	mov    $0x0,%edx
801003cf:	f7 f1                	div    %ecx
801003d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801003d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801003d8:	75 c7                	jne    801003a1 <printint+0x39>

  if(sign)
801003da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801003de:	74 2a                	je     8010040a <printint+0xa2>
    buf[i++] = '-';
801003e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003e3:	8d 50 01             	lea    0x1(%eax),%edx
801003e6:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003e9:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
801003ee:	eb 1a                	jmp    8010040a <printint+0xa2>
    consputc(buf[i]);
801003f0:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003f6:	01 d0                	add    %edx,%eax
801003f8:	0f b6 00             	movzbl (%eax),%eax
801003fb:	0f be c0             	movsbl %al,%eax
801003fe:	83 ec 0c             	sub    $0xc,%esp
80100401:	50                   	push   %eax
80100402:	e8 36 04 00 00       	call   8010083d <consputc>
80100407:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
8010040a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
8010040e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100412:	79 dc                	jns    801003f0 <printint+0x88>
}
80100414:	90                   	nop
80100415:	90                   	nop
80100416:	c9                   	leave  
80100417:	c3                   	ret    

80100418 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100418:	f3 0f 1e fb          	endbr32 
8010041c:	55                   	push   %ebp
8010041d:	89 e5                	mov    %esp,%ebp
8010041f:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100422:	a1 f4 d5 10 80       	mov    0x8010d5f4,%eax
80100427:	89 45 e8             	mov    %eax,-0x18(%ebp)
  //changed: added holding check
  if(locking && !holding(&cons.lock))
8010042a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010042e:	74 24                	je     80100454 <cprintf+0x3c>
80100430:	83 ec 0c             	sub    $0xc,%esp
80100433:	68 c0 d5 10 80       	push   $0x8010d5c0
80100438:	e8 b6 52 00 00       	call   801056f3 <holding>
8010043d:	83 c4 10             	add    $0x10,%esp
80100440:	85 c0                	test   %eax,%eax
80100442:	75 10                	jne    80100454 <cprintf+0x3c>
    acquire(&cons.lock);
80100444:	83 ec 0c             	sub    $0xc,%esp
80100447:	68 c0 d5 10 80       	push   $0x8010d5c0
8010044c:	e8 5b 51 00 00       	call   801055ac <acquire>
80100451:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100454:	8b 45 08             	mov    0x8(%ebp),%eax
80100457:	85 c0                	test   %eax,%eax
80100459:	75 0d                	jne    80100468 <cprintf+0x50>
    panic("null fmt");
8010045b:	83 ec 0c             	sub    $0xc,%esp
8010045e:	68 f8 97 10 80       	push   $0x801097f8
80100463:	e8 a0 01 00 00       	call   80100608 <panic>

  argp = (uint*)(void*)(&fmt + 1);
80100468:	8d 45 0c             	lea    0xc(%ebp),%eax
8010046b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010046e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100475:	e9 52 01 00 00       	jmp    801005cc <cprintf+0x1b4>
    if(c != '%'){
8010047a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
8010047e:	74 13                	je     80100493 <cprintf+0x7b>
      consputc(c);
80100480:	83 ec 0c             	sub    $0xc,%esp
80100483:	ff 75 e4             	pushl  -0x1c(%ebp)
80100486:	e8 b2 03 00 00       	call   8010083d <consputc>
8010048b:	83 c4 10             	add    $0x10,%esp
      continue;
8010048e:	e9 35 01 00 00       	jmp    801005c8 <cprintf+0x1b0>
    }
    c = fmt[++i] & 0xff;
80100493:	8b 55 08             	mov    0x8(%ebp),%edx
80100496:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010049a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010049d:	01 d0                	add    %edx,%eax
8010049f:	0f b6 00             	movzbl (%eax),%eax
801004a2:	0f be c0             	movsbl %al,%eax
801004a5:	25 ff 00 00 00       	and    $0xff,%eax
801004aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
801004ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801004b1:	0f 84 37 01 00 00    	je     801005ee <cprintf+0x1d6>
      break;
    switch(c){
801004b7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801004bb:	0f 84 dc 00 00 00    	je     8010059d <cprintf+0x185>
801004c1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801004c5:	0f 8c e1 00 00 00    	jl     801005ac <cprintf+0x194>
801004cb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
801004cf:	0f 8f d7 00 00 00    	jg     801005ac <cprintf+0x194>
801004d5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
801004d9:	0f 8c cd 00 00 00    	jl     801005ac <cprintf+0x194>
801004df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004e2:	83 e8 63             	sub    $0x63,%eax
801004e5:	83 f8 15             	cmp    $0x15,%eax
801004e8:	0f 87 be 00 00 00    	ja     801005ac <cprintf+0x194>
801004ee:	8b 04 85 08 98 10 80 	mov    -0x7fef67f8(,%eax,4),%eax
801004f5:	3e ff e0             	notrack jmp *%eax
    case 'd':
      printint(*argp++, 10, 1);
801004f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004fb:	8d 50 04             	lea    0x4(%eax),%edx
801004fe:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100501:	8b 00                	mov    (%eax),%eax
80100503:	83 ec 04             	sub    $0x4,%esp
80100506:	6a 01                	push   $0x1
80100508:	6a 0a                	push   $0xa
8010050a:	50                   	push   %eax
8010050b:	e8 58 fe ff ff       	call   80100368 <printint>
80100510:	83 c4 10             	add    $0x10,%esp
      break;
80100513:	e9 b0 00 00 00       	jmp    801005c8 <cprintf+0x1b0>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100518:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010051b:	8d 50 04             	lea    0x4(%eax),%edx
8010051e:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100521:	8b 00                	mov    (%eax),%eax
80100523:	83 ec 04             	sub    $0x4,%esp
80100526:	6a 00                	push   $0x0
80100528:	6a 10                	push   $0x10
8010052a:	50                   	push   %eax
8010052b:	e8 38 fe ff ff       	call   80100368 <printint>
80100530:	83 c4 10             	add    $0x10,%esp
      break;
80100533:	e9 90 00 00 00       	jmp    801005c8 <cprintf+0x1b0>
    case 's':
      if((s = (char*)*argp++) == 0)
80100538:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010053b:	8d 50 04             	lea    0x4(%eax),%edx
8010053e:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100541:	8b 00                	mov    (%eax),%eax
80100543:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100546:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010054a:	75 22                	jne    8010056e <cprintf+0x156>
        s = "(null)";
8010054c:	c7 45 ec 01 98 10 80 	movl   $0x80109801,-0x14(%ebp)
      for(; *s; s++)
80100553:	eb 19                	jmp    8010056e <cprintf+0x156>
        consputc(*s);
80100555:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100558:	0f b6 00             	movzbl (%eax),%eax
8010055b:	0f be c0             	movsbl %al,%eax
8010055e:	83 ec 0c             	sub    $0xc,%esp
80100561:	50                   	push   %eax
80100562:	e8 d6 02 00 00       	call   8010083d <consputc>
80100567:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
8010056a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010056e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100571:	0f b6 00             	movzbl (%eax),%eax
80100574:	84 c0                	test   %al,%al
80100576:	75 dd                	jne    80100555 <cprintf+0x13d>
      break;
80100578:	eb 4e                	jmp    801005c8 <cprintf+0x1b0>
    case 'c':
      s = (char*)argp++;
8010057a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010057d:	8d 50 04             	lea    0x4(%eax),%edx
80100580:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100583:	89 45 ec             	mov    %eax,-0x14(%ebp)
      consputc(*(s));
80100586:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100589:	0f b6 00             	movzbl (%eax),%eax
8010058c:	0f be c0             	movsbl %al,%eax
8010058f:	83 ec 0c             	sub    $0xc,%esp
80100592:	50                   	push   %eax
80100593:	e8 a5 02 00 00       	call   8010083d <consputc>
80100598:	83 c4 10             	add    $0x10,%esp
      break;
8010059b:	eb 2b                	jmp    801005c8 <cprintf+0x1b0>
    case '%':
      consputc('%');
8010059d:	83 ec 0c             	sub    $0xc,%esp
801005a0:	6a 25                	push   $0x25
801005a2:	e8 96 02 00 00       	call   8010083d <consputc>
801005a7:	83 c4 10             	add    $0x10,%esp
      break;
801005aa:	eb 1c                	jmp    801005c8 <cprintf+0x1b0>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801005ac:	83 ec 0c             	sub    $0xc,%esp
801005af:	6a 25                	push   $0x25
801005b1:	e8 87 02 00 00       	call   8010083d <consputc>
801005b6:	83 c4 10             	add    $0x10,%esp
      consputc(c);
801005b9:	83 ec 0c             	sub    $0xc,%esp
801005bc:	ff 75 e4             	pushl  -0x1c(%ebp)
801005bf:	e8 79 02 00 00       	call   8010083d <consputc>
801005c4:	83 c4 10             	add    $0x10,%esp
      break;
801005c7:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801005c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005cc:	8b 55 08             	mov    0x8(%ebp),%edx
801005cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d2:	01 d0                	add    %edx,%eax
801005d4:	0f b6 00             	movzbl (%eax),%eax
801005d7:	0f be c0             	movsbl %al,%eax
801005da:	25 ff 00 00 00       	and    $0xff,%eax
801005df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801005e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801005e6:	0f 85 8e fe ff ff    	jne    8010047a <cprintf+0x62>
801005ec:	eb 01                	jmp    801005ef <cprintf+0x1d7>
      break;
801005ee:	90                   	nop
    }
  }

  if(locking)
801005ef:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801005f3:	74 10                	je     80100605 <cprintf+0x1ed>
    release(&cons.lock);
801005f5:	83 ec 0c             	sub    $0xc,%esp
801005f8:	68 c0 d5 10 80       	push   $0x8010d5c0
801005fd:	e8 1c 50 00 00       	call   8010561e <release>
80100602:	83 c4 10             	add    $0x10,%esp
}
80100605:	90                   	nop
80100606:	c9                   	leave  
80100607:	c3                   	ret    

80100608 <panic>:

void
panic(char *s)
{
80100608:	f3 0f 1e fb          	endbr32 
8010060c:	55                   	push   %ebp
8010060d:	89 e5                	mov    %esp,%ebp
8010060f:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];

  cli();
80100612:	e8 4a fd ff ff       	call   80100361 <cli>
  cons.locking = 0;
80100617:	c7 05 f4 d5 10 80 00 	movl   $0x0,0x8010d5f4
8010061e:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100621:	e8 65 2b 00 00       	call   8010318b <lapicid>
80100626:	83 ec 08             	sub    $0x8,%esp
80100629:	50                   	push   %eax
8010062a:	68 60 98 10 80       	push   $0x80109860
8010062f:	e8 e4 fd ff ff       	call   80100418 <cprintf>
80100634:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100637:	8b 45 08             	mov    0x8(%ebp),%eax
8010063a:	83 ec 0c             	sub    $0xc,%esp
8010063d:	50                   	push   %eax
8010063e:	e8 d5 fd ff ff       	call   80100418 <cprintf>
80100643:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80100646:	83 ec 0c             	sub    $0xc,%esp
80100649:	68 74 98 10 80       	push   $0x80109874
8010064e:	e8 c5 fd ff ff       	call   80100418 <cprintf>
80100653:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
80100656:	83 ec 08             	sub    $0x8,%esp
80100659:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010065c:	50                   	push   %eax
8010065d:	8d 45 08             	lea    0x8(%ebp),%eax
80100660:	50                   	push   %eax
80100661:	e8 0e 50 00 00       	call   80105674 <getcallerpcs>
80100666:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100669:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100670:	eb 1c                	jmp    8010068e <panic+0x86>
    cprintf(" %p", pcs[i]);
80100672:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100675:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100679:	83 ec 08             	sub    $0x8,%esp
8010067c:	50                   	push   %eax
8010067d:	68 76 98 10 80       	push   $0x80109876
80100682:	e8 91 fd ff ff       	call   80100418 <cprintf>
80100687:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
8010068a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010068e:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80100692:	7e de                	jle    80100672 <panic+0x6a>
  panicked = 1; // freeze other CPU
80100694:	c7 05 a0 d5 10 80 01 	movl   $0x1,0x8010d5a0
8010069b:	00 00 00 
  for(;;)
8010069e:	eb fe                	jmp    8010069e <panic+0x96>

801006a0 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801006a0:	f3 0f 1e fb          	endbr32 
801006a4:	55                   	push   %ebp
801006a5:	89 e5                	mov    %esp,%ebp
801006a7:	53                   	push   %ebx
801006a8:	83 ec 14             	sub    $0x14,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801006ab:	6a 0e                	push   $0xe
801006ad:	68 d4 03 00 00       	push   $0x3d4
801006b2:	e8 89 fc ff ff       	call   80100340 <outb>
801006b7:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
801006ba:	68 d5 03 00 00       	push   $0x3d5
801006bf:	e8 5f fc ff ff       	call   80100323 <inb>
801006c4:	83 c4 04             	add    $0x4,%esp
801006c7:	0f b6 c0             	movzbl %al,%eax
801006ca:	c1 e0 08             	shl    $0x8,%eax
801006cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801006d0:	6a 0f                	push   $0xf
801006d2:	68 d4 03 00 00       	push   $0x3d4
801006d7:	e8 64 fc ff ff       	call   80100340 <outb>
801006dc:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
801006df:	68 d5 03 00 00       	push   $0x3d5
801006e4:	e8 3a fc ff ff       	call   80100323 <inb>
801006e9:	83 c4 04             	add    $0x4,%esp
801006ec:	0f b6 c0             	movzbl %al,%eax
801006ef:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
801006f2:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
801006f6:	75 30                	jne    80100728 <cgaputc+0x88>
    pos += 80 - pos%80;
801006f8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006fb:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100700:	89 c8                	mov    %ecx,%eax
80100702:	f7 ea                	imul   %edx
80100704:	c1 fa 05             	sar    $0x5,%edx
80100707:	89 c8                	mov    %ecx,%eax
80100709:	c1 f8 1f             	sar    $0x1f,%eax
8010070c:	29 c2                	sub    %eax,%edx
8010070e:	89 d0                	mov    %edx,%eax
80100710:	c1 e0 02             	shl    $0x2,%eax
80100713:	01 d0                	add    %edx,%eax
80100715:	c1 e0 04             	shl    $0x4,%eax
80100718:	29 c1                	sub    %eax,%ecx
8010071a:	89 ca                	mov    %ecx,%edx
8010071c:	b8 50 00 00 00       	mov    $0x50,%eax
80100721:	29 d0                	sub    %edx,%eax
80100723:	01 45 f4             	add    %eax,-0xc(%ebp)
80100726:	eb 38                	jmp    80100760 <cgaputc+0xc0>
  else if(c == BACKSPACE){
80100728:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010072f:	75 0c                	jne    8010073d <cgaputc+0x9d>
    if(pos > 0) --pos;
80100731:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100735:	7e 29                	jle    80100760 <cgaputc+0xc0>
80100737:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
8010073b:	eb 23                	jmp    80100760 <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010073d:	8b 45 08             	mov    0x8(%ebp),%eax
80100740:	0f b6 c0             	movzbl %al,%eax
80100743:	80 cc 07             	or     $0x7,%ah
80100746:	89 c3                	mov    %eax,%ebx
80100748:	8b 0d 00 b0 10 80    	mov    0x8010b000,%ecx
8010074e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100751:	8d 50 01             	lea    0x1(%eax),%edx
80100754:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100757:	01 c0                	add    %eax,%eax
80100759:	01 c8                	add    %ecx,%eax
8010075b:	89 da                	mov    %ebx,%edx
8010075d:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
80100760:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100764:	78 09                	js     8010076f <cgaputc+0xcf>
80100766:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
8010076d:	7e 0d                	jle    8010077c <cgaputc+0xdc>
    panic("pos under/overflow");
8010076f:	83 ec 0c             	sub    $0xc,%esp
80100772:	68 7a 98 10 80       	push   $0x8010987a
80100777:	e8 8c fe ff ff       	call   80100608 <panic>

  if((pos/80) >= 24){  // Scroll up.
8010077c:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100783:	7e 4c                	jle    801007d1 <cgaputc+0x131>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100785:	a1 00 b0 10 80       	mov    0x8010b000,%eax
8010078a:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
80100790:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100795:	83 ec 04             	sub    $0x4,%esp
80100798:	68 60 0e 00 00       	push   $0xe60
8010079d:	52                   	push   %edx
8010079e:	50                   	push   %eax
8010079f:	e8 6e 51 00 00       	call   80105912 <memmove>
801007a4:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801007a7:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801007ab:	b8 80 07 00 00       	mov    $0x780,%eax
801007b0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801007b3:	8d 14 00             	lea    (%eax,%eax,1),%edx
801007b6:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801007bb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801007be:	01 c9                	add    %ecx,%ecx
801007c0:	01 c8                	add    %ecx,%eax
801007c2:	83 ec 04             	sub    $0x4,%esp
801007c5:	52                   	push   %edx
801007c6:	6a 00                	push   $0x0
801007c8:	50                   	push   %eax
801007c9:	e8 7d 50 00 00       	call   8010584b <memset>
801007ce:	83 c4 10             	add    $0x10,%esp
  }

  outb(CRTPORT, 14);
801007d1:	83 ec 08             	sub    $0x8,%esp
801007d4:	6a 0e                	push   $0xe
801007d6:	68 d4 03 00 00       	push   $0x3d4
801007db:	e8 60 fb ff ff       	call   80100340 <outb>
801007e0:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
801007e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007e6:	c1 f8 08             	sar    $0x8,%eax
801007e9:	0f b6 c0             	movzbl %al,%eax
801007ec:	83 ec 08             	sub    $0x8,%esp
801007ef:	50                   	push   %eax
801007f0:	68 d5 03 00 00       	push   $0x3d5
801007f5:	e8 46 fb ff ff       	call   80100340 <outb>
801007fa:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
801007fd:	83 ec 08             	sub    $0x8,%esp
80100800:	6a 0f                	push   $0xf
80100802:	68 d4 03 00 00       	push   $0x3d4
80100807:	e8 34 fb ff ff       	call   80100340 <outb>
8010080c:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
8010080f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100812:	0f b6 c0             	movzbl %al,%eax
80100815:	83 ec 08             	sub    $0x8,%esp
80100818:	50                   	push   %eax
80100819:	68 d5 03 00 00       	push   $0x3d5
8010081e:	e8 1d fb ff ff       	call   80100340 <outb>
80100823:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
80100826:	a1 00 b0 10 80       	mov    0x8010b000,%eax
8010082b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010082e:	01 d2                	add    %edx,%edx
80100830:	01 d0                	add    %edx,%eax
80100832:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100837:	90                   	nop
80100838:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010083b:	c9                   	leave  
8010083c:	c3                   	ret    

8010083d <consputc>:

void
consputc(int c)
{
8010083d:	f3 0f 1e fb          	endbr32 
80100841:	55                   	push   %ebp
80100842:	89 e5                	mov    %esp,%ebp
80100844:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100847:	a1 a0 d5 10 80       	mov    0x8010d5a0,%eax
8010084c:	85 c0                	test   %eax,%eax
8010084e:	74 07                	je     80100857 <consputc+0x1a>
    cli();
80100850:	e8 0c fb ff ff       	call   80100361 <cli>
    for(;;)
80100855:	eb fe                	jmp    80100855 <consputc+0x18>
      ;
  }

  if(c == BACKSPACE){
80100857:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010085e:	75 29                	jne    80100889 <consputc+0x4c>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	6a 08                	push   $0x8
80100865:	e8 e6 6a 00 00       	call   80107350 <uartputc>
8010086a:	83 c4 10             	add    $0x10,%esp
8010086d:	83 ec 0c             	sub    $0xc,%esp
80100870:	6a 20                	push   $0x20
80100872:	e8 d9 6a 00 00       	call   80107350 <uartputc>
80100877:	83 c4 10             	add    $0x10,%esp
8010087a:	83 ec 0c             	sub    $0xc,%esp
8010087d:	6a 08                	push   $0x8
8010087f:	e8 cc 6a 00 00       	call   80107350 <uartputc>
80100884:	83 c4 10             	add    $0x10,%esp
80100887:	eb 0e                	jmp    80100897 <consputc+0x5a>
  } else
    uartputc(c);
80100889:	83 ec 0c             	sub    $0xc,%esp
8010088c:	ff 75 08             	pushl  0x8(%ebp)
8010088f:	e8 bc 6a 00 00       	call   80107350 <uartputc>
80100894:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
80100897:	83 ec 0c             	sub    $0xc,%esp
8010089a:	ff 75 08             	pushl  0x8(%ebp)
8010089d:	e8 fe fd ff ff       	call   801006a0 <cgaputc>
801008a2:	83 c4 10             	add    $0x10,%esp
}
801008a5:	90                   	nop
801008a6:	c9                   	leave  
801008a7:	c3                   	ret    

801008a8 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801008a8:	f3 0f 1e fb          	endbr32 
801008ac:	55                   	push   %ebp
801008ad:	89 e5                	mov    %esp,%ebp
801008af:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
801008b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
801008b9:	83 ec 0c             	sub    $0xc,%esp
801008bc:	68 c0 d5 10 80       	push   $0x8010d5c0
801008c1:	e8 e6 4c 00 00       	call   801055ac <acquire>
801008c6:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
801008c9:	e9 52 01 00 00       	jmp    80100a20 <consoleintr+0x178>
    switch(c){
801008ce:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
801008d2:	0f 84 81 00 00 00    	je     80100959 <consoleintr+0xb1>
801008d8:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
801008dc:	0f 8f ac 00 00 00    	jg     8010098e <consoleintr+0xe6>
801008e2:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
801008e6:	74 43                	je     8010092b <consoleintr+0x83>
801008e8:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
801008ec:	0f 8f 9c 00 00 00    	jg     8010098e <consoleintr+0xe6>
801008f2:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
801008f6:	74 61                	je     80100959 <consoleintr+0xb1>
801008f8:	83 7d f0 10          	cmpl   $0x10,-0x10(%ebp)
801008fc:	0f 85 8c 00 00 00    	jne    8010098e <consoleintr+0xe6>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100902:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100909:	e9 12 01 00 00       	jmp    80100a20 <consoleintr+0x178>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
8010090e:	a1 48 30 11 80       	mov    0x80113048,%eax
80100913:	83 e8 01             	sub    $0x1,%eax
80100916:	a3 48 30 11 80       	mov    %eax,0x80113048
        consputc(BACKSPACE);
8010091b:	83 ec 0c             	sub    $0xc,%esp
8010091e:	68 00 01 00 00       	push   $0x100
80100923:	e8 15 ff ff ff       	call   8010083d <consputc>
80100928:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
8010092b:	8b 15 48 30 11 80    	mov    0x80113048,%edx
80100931:	a1 44 30 11 80       	mov    0x80113044,%eax
80100936:	39 c2                	cmp    %eax,%edx
80100938:	0f 84 e2 00 00 00    	je     80100a20 <consoleintr+0x178>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010093e:	a1 48 30 11 80       	mov    0x80113048,%eax
80100943:	83 e8 01             	sub    $0x1,%eax
80100946:	83 e0 7f             	and    $0x7f,%eax
80100949:	0f b6 80 c0 2f 11 80 	movzbl -0x7feed040(%eax),%eax
      while(input.e != input.w &&
80100950:	3c 0a                	cmp    $0xa,%al
80100952:	75 ba                	jne    8010090e <consoleintr+0x66>
      }
      break;
80100954:	e9 c7 00 00 00       	jmp    80100a20 <consoleintr+0x178>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100959:	8b 15 48 30 11 80    	mov    0x80113048,%edx
8010095f:	a1 44 30 11 80       	mov    0x80113044,%eax
80100964:	39 c2                	cmp    %eax,%edx
80100966:	0f 84 b4 00 00 00    	je     80100a20 <consoleintr+0x178>
        input.e--;
8010096c:	a1 48 30 11 80       	mov    0x80113048,%eax
80100971:	83 e8 01             	sub    $0x1,%eax
80100974:	a3 48 30 11 80       	mov    %eax,0x80113048
        consputc(BACKSPACE);
80100979:	83 ec 0c             	sub    $0xc,%esp
8010097c:	68 00 01 00 00       	push   $0x100
80100981:	e8 b7 fe ff ff       	call   8010083d <consputc>
80100986:	83 c4 10             	add    $0x10,%esp
      }
      break;
80100989:	e9 92 00 00 00       	jmp    80100a20 <consoleintr+0x178>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010098e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100992:	0f 84 87 00 00 00    	je     80100a1f <consoleintr+0x177>
80100998:	8b 15 48 30 11 80    	mov    0x80113048,%edx
8010099e:	a1 40 30 11 80       	mov    0x80113040,%eax
801009a3:	29 c2                	sub    %eax,%edx
801009a5:	89 d0                	mov    %edx,%eax
801009a7:	83 f8 7f             	cmp    $0x7f,%eax
801009aa:	77 73                	ja     80100a1f <consoleintr+0x177>
        c = (c == '\r') ? '\n' : c;
801009ac:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801009b0:	74 05                	je     801009b7 <consoleintr+0x10f>
801009b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801009b5:	eb 05                	jmp    801009bc <consoleintr+0x114>
801009b7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801009bf:	a1 48 30 11 80       	mov    0x80113048,%eax
801009c4:	8d 50 01             	lea    0x1(%eax),%edx
801009c7:	89 15 48 30 11 80    	mov    %edx,0x80113048
801009cd:	83 e0 7f             	and    $0x7f,%eax
801009d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801009d3:	88 90 c0 2f 11 80    	mov    %dl,-0x7feed040(%eax)
        consputc(c);
801009d9:	83 ec 0c             	sub    $0xc,%esp
801009dc:	ff 75 f0             	pushl  -0x10(%ebp)
801009df:	e8 59 fe ff ff       	call   8010083d <consputc>
801009e4:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009e7:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009eb:	74 18                	je     80100a05 <consoleintr+0x15d>
801009ed:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009f1:	74 12                	je     80100a05 <consoleintr+0x15d>
801009f3:	a1 48 30 11 80       	mov    0x80113048,%eax
801009f8:	8b 15 40 30 11 80    	mov    0x80113040,%edx
801009fe:	83 ea 80             	sub    $0xffffff80,%edx
80100a01:	39 d0                	cmp    %edx,%eax
80100a03:	75 1a                	jne    80100a1f <consoleintr+0x177>
          input.w = input.e;
80100a05:	a1 48 30 11 80       	mov    0x80113048,%eax
80100a0a:	a3 44 30 11 80       	mov    %eax,0x80113044
          wakeup(&input.r);
80100a0f:	83 ec 0c             	sub    $0xc,%esp
80100a12:	68 40 30 11 80       	push   $0x80113040
80100a17:	e8 10 48 00 00       	call   8010522c <wakeup>
80100a1c:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100a1f:	90                   	nop
  while((c = getc()) >= 0){
80100a20:	8b 45 08             	mov    0x8(%ebp),%eax
80100a23:	ff d0                	call   *%eax
80100a25:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100a28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100a2c:	0f 89 9c fe ff ff    	jns    801008ce <consoleintr+0x26>
    }
  }
  release(&cons.lock);
80100a32:	83 ec 0c             	sub    $0xc,%esp
80100a35:	68 c0 d5 10 80       	push   $0x8010d5c0
80100a3a:	e8 df 4b 00 00       	call   8010561e <release>
80100a3f:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
80100a42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100a46:	74 05                	je     80100a4d <consoleintr+0x1a5>
    procdump();  // now call procdump() wo. cons.lock held
80100a48:	e8 a5 48 00 00       	call   801052f2 <procdump>
  }
}
80100a4d:	90                   	nop
80100a4e:	c9                   	leave  
80100a4f:	c3                   	ret    

80100a50 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100a50:	f3 0f 1e fb          	endbr32 
80100a54:	55                   	push   %ebp
80100a55:	89 e5                	mov    %esp,%ebp
80100a57:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100a5a:	83 ec 0c             	sub    $0xc,%esp
80100a5d:	ff 75 08             	pushl  0x8(%ebp)
80100a60:	e8 e0 11 00 00       	call   80101c45 <iunlock>
80100a65:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a68:	8b 45 10             	mov    0x10(%ebp),%eax
80100a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a6e:	83 ec 0c             	sub    $0xc,%esp
80100a71:	68 c0 d5 10 80       	push   $0x8010d5c0
80100a76:	e8 31 4b 00 00       	call   801055ac <acquire>
80100a7b:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100a7e:	e9 ab 00 00 00       	jmp    80100b2e <consoleread+0xde>
    while(input.r == input.w){
      if(myproc()->killed){
80100a83:	e8 ce 3a 00 00       	call   80104556 <myproc>
80100a88:	8b 40 24             	mov    0x24(%eax),%eax
80100a8b:	85 c0                	test   %eax,%eax
80100a8d:	74 28                	je     80100ab7 <consoleread+0x67>
        release(&cons.lock);
80100a8f:	83 ec 0c             	sub    $0xc,%esp
80100a92:	68 c0 d5 10 80       	push   $0x8010d5c0
80100a97:	e8 82 4b 00 00       	call   8010561e <release>
80100a9c:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a9f:	83 ec 0c             	sub    $0xc,%esp
80100aa2:	ff 75 08             	pushl  0x8(%ebp)
80100aa5:	e8 84 10 00 00       	call   80101b2e <ilock>
80100aaa:	83 c4 10             	add    $0x10,%esp
        return -1;
80100aad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ab2:	e9 ab 00 00 00       	jmp    80100b62 <consoleread+0x112>
      }
      sleep(&input.r, &cons.lock);
80100ab7:	83 ec 08             	sub    $0x8,%esp
80100aba:	68 c0 d5 10 80       	push   $0x8010d5c0
80100abf:	68 40 30 11 80       	push   $0x80113040
80100ac4:	e8 71 46 00 00       	call   8010513a <sleep>
80100ac9:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
80100acc:	8b 15 40 30 11 80    	mov    0x80113040,%edx
80100ad2:	a1 44 30 11 80       	mov    0x80113044,%eax
80100ad7:	39 c2                	cmp    %eax,%edx
80100ad9:	74 a8                	je     80100a83 <consoleread+0x33>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100adb:	a1 40 30 11 80       	mov    0x80113040,%eax
80100ae0:	8d 50 01             	lea    0x1(%eax),%edx
80100ae3:	89 15 40 30 11 80    	mov    %edx,0x80113040
80100ae9:	83 e0 7f             	and    $0x7f,%eax
80100aec:	0f b6 80 c0 2f 11 80 	movzbl -0x7feed040(%eax),%eax
80100af3:	0f be c0             	movsbl %al,%eax
80100af6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100af9:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100afd:	75 17                	jne    80100b16 <consoleread+0xc6>
      if(n < target){
80100aff:	8b 45 10             	mov    0x10(%ebp),%eax
80100b02:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100b05:	76 2f                	jbe    80100b36 <consoleread+0xe6>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100b07:	a1 40 30 11 80       	mov    0x80113040,%eax
80100b0c:	83 e8 01             	sub    $0x1,%eax
80100b0f:	a3 40 30 11 80       	mov    %eax,0x80113040
      }
      break;
80100b14:	eb 20                	jmp    80100b36 <consoleread+0xe6>
    }
    *dst++ = c;
80100b16:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b19:	8d 50 01             	lea    0x1(%eax),%edx
80100b1c:	89 55 0c             	mov    %edx,0xc(%ebp)
80100b1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100b22:	88 10                	mov    %dl,(%eax)
    --n;
80100b24:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100b28:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100b2c:	74 0b                	je     80100b39 <consoleread+0xe9>
  while(n > 0){
80100b2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100b32:	7f 98                	jg     80100acc <consoleread+0x7c>
80100b34:	eb 04                	jmp    80100b3a <consoleread+0xea>
      break;
80100b36:	90                   	nop
80100b37:	eb 01                	jmp    80100b3a <consoleread+0xea>
      break;
80100b39:	90                   	nop
  }
  release(&cons.lock);
80100b3a:	83 ec 0c             	sub    $0xc,%esp
80100b3d:	68 c0 d5 10 80       	push   $0x8010d5c0
80100b42:	e8 d7 4a 00 00       	call   8010561e <release>
80100b47:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b4a:	83 ec 0c             	sub    $0xc,%esp
80100b4d:	ff 75 08             	pushl  0x8(%ebp)
80100b50:	e8 d9 0f 00 00       	call   80101b2e <ilock>
80100b55:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100b58:	8b 45 10             	mov    0x10(%ebp),%eax
80100b5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b5e:	29 c2                	sub    %eax,%edx
80100b60:	89 d0                	mov    %edx,%eax
}
80100b62:	c9                   	leave  
80100b63:	c3                   	ret    

80100b64 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100b64:	f3 0f 1e fb          	endbr32 
80100b68:	55                   	push   %ebp
80100b69:	89 e5                	mov    %esp,%ebp
80100b6b:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100b6e:	83 ec 0c             	sub    $0xc,%esp
80100b71:	ff 75 08             	pushl  0x8(%ebp)
80100b74:	e8 cc 10 00 00       	call   80101c45 <iunlock>
80100b79:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b7c:	83 ec 0c             	sub    $0xc,%esp
80100b7f:	68 c0 d5 10 80       	push   $0x8010d5c0
80100b84:	e8 23 4a 00 00       	call   801055ac <acquire>
80100b89:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b93:	eb 21                	jmp    80100bb6 <consolewrite+0x52>
    consputc(buf[i] & 0xff);
80100b95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b98:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b9b:	01 d0                	add    %edx,%eax
80100b9d:	0f b6 00             	movzbl (%eax),%eax
80100ba0:	0f be c0             	movsbl %al,%eax
80100ba3:	0f b6 c0             	movzbl %al,%eax
80100ba6:	83 ec 0c             	sub    $0xc,%esp
80100ba9:	50                   	push   %eax
80100baa:	e8 8e fc ff ff       	call   8010083d <consputc>
80100baf:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100bb2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100bb9:	3b 45 10             	cmp    0x10(%ebp),%eax
80100bbc:	7c d7                	jl     80100b95 <consolewrite+0x31>
  release(&cons.lock);
80100bbe:	83 ec 0c             	sub    $0xc,%esp
80100bc1:	68 c0 d5 10 80       	push   $0x8010d5c0
80100bc6:	e8 53 4a 00 00       	call   8010561e <release>
80100bcb:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100bce:	83 ec 0c             	sub    $0xc,%esp
80100bd1:	ff 75 08             	pushl  0x8(%ebp)
80100bd4:	e8 55 0f 00 00       	call   80101b2e <ilock>
80100bd9:	83 c4 10             	add    $0x10,%esp

  return n;
80100bdc:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100bdf:	c9                   	leave  
80100be0:	c3                   	ret    

80100be1 <consoleinit>:

void
consoleinit(void)
{
80100be1:	f3 0f 1e fb          	endbr32 
80100be5:	55                   	push   %ebp
80100be6:	89 e5                	mov    %esp,%ebp
80100be8:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100beb:	83 ec 08             	sub    $0x8,%esp
80100bee:	68 8d 98 10 80       	push   $0x8010988d
80100bf3:	68 c0 d5 10 80       	push   $0x8010d5c0
80100bf8:	e8 89 49 00 00       	call   80105586 <initlock>
80100bfd:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100c00:	c7 05 0c 3a 11 80 64 	movl   $0x80100b64,0x80113a0c
80100c07:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100c0a:	c7 05 08 3a 11 80 50 	movl   $0x80100a50,0x80113a08
80100c11:	0a 10 80 
  cons.locking = 1;
80100c14:	c7 05 f4 d5 10 80 01 	movl   $0x1,0x8010d5f4
80100c1b:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100c1e:	83 ec 08             	sub    $0x8,%esp
80100c21:	6a 00                	push   $0x0
80100c23:	6a 01                	push   $0x1
80100c25:	e8 6e 20 00 00       	call   80102c98 <ioapicenable>
80100c2a:	83 c4 10             	add    $0x10,%esp
}
80100c2d:	90                   	nop
80100c2e:	c9                   	leave  
80100c2f:	c3                   	ret    

80100c30 <exec>:
#include "defs.h"
#include "x86.h"
#include "elf.h"

int exec(char *path, char **argv)
{
80100c30:	f3 0f 1e fb          	endbr32 
80100c34:	55                   	push   %ebp
80100c35:	89 e5                	mov    %esp,%ebp
80100c37:	81 ec 18 01 00 00    	sub    $0x118,%esp
  uint argc, sz, sp, ustack[3 + MAXARG + 1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100c3d:	e8 14 39 00 00       	call   80104556 <myproc>
80100c42:	89 45 d0             	mov    %eax,-0x30(%ebp)
  

  begin_op();
80100c45:	e8 b3 2a 00 00       	call   801036fd <begin_op>

  if ((ip = namei(path)) == 0)
80100c4a:	83 ec 0c             	sub    $0xc,%esp
80100c4d:	ff 75 08             	pushl  0x8(%ebp)
80100c50:	e8 44 1a 00 00       	call   80102699 <namei>
80100c55:	83 c4 10             	add    $0x10,%esp
80100c58:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c5b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c5f:	75 1f                	jne    80100c80 <exec+0x50>
  {
    end_op();
80100c61:	e8 27 2b 00 00       	call   8010378d <end_op>
    cprintf("exec: fail\n");
80100c66:	83 ec 0c             	sub    $0xc,%esp
80100c69:	68 95 98 10 80       	push   $0x80109895
80100c6e:	e8 a5 f7 ff ff       	call   80100418 <cprintf>
80100c73:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c7b:	e9 44 04 00 00       	jmp    801010c4 <exec+0x494>
  }
  ilock(ip);
80100c80:	83 ec 0c             	sub    $0xc,%esp
80100c83:	ff 75 d8             	pushl  -0x28(%ebp)
80100c86:	e8 a3 0e 00 00       	call   80101b2e <ilock>
80100c8b:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c8e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if (readi(ip, (char *)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c95:	6a 34                	push   $0x34
80100c97:	6a 00                	push   $0x0
80100c99:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100c9f:	50                   	push   %eax
80100ca0:	ff 75 d8             	pushl  -0x28(%ebp)
80100ca3:	e8 8e 13 00 00       	call   80102036 <readi>
80100ca8:	83 c4 10             	add    $0x10,%esp
80100cab:	83 f8 34             	cmp    $0x34,%eax
80100cae:	0f 85 b9 03 00 00    	jne    8010106d <exec+0x43d>
    goto bad;
  if (elf.magic != ELF_MAGIC)
80100cb4:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100cba:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100cbf:	0f 85 ab 03 00 00    	jne    80101070 <exec+0x440>
    goto bad;

  if ((pgdir = setupkvm()) == 0)
80100cc5:	e8 bd 76 00 00       	call   80108387 <setupkvm>
80100cca:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100ccd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100cd1:	0f 84 9c 03 00 00    	je     80101073 <exec+0x443>
    goto bad;

  // Load program into memory.
  sz = 0;
80100cd7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
80100cde:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100ce5:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100ceb:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cee:	e9 de 00 00 00       	jmp    80100dd1 <exec+0x1a1>
  {
    if (readi(ip, (char *)&ph, off, sizeof(ph)) != sizeof(ph))
80100cf3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cf6:	6a 20                	push   $0x20
80100cf8:	50                   	push   %eax
80100cf9:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100cff:	50                   	push   %eax
80100d00:	ff 75 d8             	pushl  -0x28(%ebp)
80100d03:	e8 2e 13 00 00       	call   80102036 <readi>
80100d08:	83 c4 10             	add    $0x10,%esp
80100d0b:	83 f8 20             	cmp    $0x20,%eax
80100d0e:	0f 85 62 03 00 00    	jne    80101076 <exec+0x446>
      goto bad;
    if (ph.type != ELF_PROG_LOAD)
80100d14:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100d1a:	83 f8 01             	cmp    $0x1,%eax
80100d1d:	0f 85 a0 00 00 00    	jne    80100dc3 <exec+0x193>
      continue;
    if (ph.memsz < ph.filesz)
80100d23:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100d29:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100d2f:	39 c2                	cmp    %eax,%edx
80100d31:	0f 82 42 03 00 00    	jb     80101079 <exec+0x449>
      goto bad;
    if (ph.vaddr + ph.memsz < ph.vaddr)
80100d37:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100d3d:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100d43:	01 c2                	add    %eax,%edx
80100d45:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d4b:	39 c2                	cmp    %eax,%edx
80100d4d:	0f 82 29 03 00 00    	jb     8010107c <exec+0x44c>
      goto bad;
    if ((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d53:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100d59:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100d5f:	01 d0                	add    %edx,%eax
80100d61:	83 ec 04             	sub    $0x4,%esp
80100d64:	50                   	push   %eax
80100d65:	ff 75 e0             	pushl  -0x20(%ebp)
80100d68:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d6b:	e8 d5 79 00 00       	call   80108745 <allocuvm>
80100d70:	83 c4 10             	add    $0x10,%esp
80100d73:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d76:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d7a:	0f 84 ff 02 00 00    	je     8010107f <exec+0x44f>
      goto bad;
    if (ph.vaddr % PGSIZE != 0)
80100d80:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d86:	25 ff 0f 00 00       	and    $0xfff,%eax
80100d8b:	85 c0                	test   %eax,%eax
80100d8d:	0f 85 ef 02 00 00    	jne    80101082 <exec+0x452>
      goto bad;
    if (loaduvm(pgdir, (char *)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d93:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100d99:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d9f:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100da5:	83 ec 0c             	sub    $0xc,%esp
80100da8:	52                   	push   %edx
80100da9:	50                   	push   %eax
80100daa:	ff 75 d8             	pushl  -0x28(%ebp)
80100dad:	51                   	push   %ecx
80100dae:	ff 75 d4             	pushl  -0x2c(%ebp)
80100db1:	e8 be 78 00 00       	call   80108674 <loaduvm>
80100db6:	83 c4 20             	add    $0x20,%esp
80100db9:	85 c0                	test   %eax,%eax
80100dbb:	0f 88 c4 02 00 00    	js     80101085 <exec+0x455>
80100dc1:	eb 01                	jmp    80100dc4 <exec+0x194>
      continue;
80100dc3:	90                   	nop
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
80100dc4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100dc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100dcb:	83 c0 20             	add    $0x20,%eax
80100dce:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100dd1:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100dd8:	0f b7 c0             	movzwl %ax,%eax
80100ddb:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80100dde:	0f 8c 0f ff ff ff    	jl     80100cf3 <exec+0xc3>
      goto bad;
  }
  iunlockput(ip);
80100de4:	83 ec 0c             	sub    $0xc,%esp
80100de7:	ff 75 d8             	pushl  -0x28(%ebp)
80100dea:	e8 7c 0f 00 00       	call   80101d6b <iunlockput>
80100def:	83 c4 10             	add    $0x10,%esp
  end_op();
80100df2:	e8 96 29 00 00       	call   8010378d <end_op>
  ip = 0;
80100df7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100dfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e01:	05 ff 0f 00 00       	add    $0xfff,%eax
80100e06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100e0b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0)
80100e0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e11:	05 00 20 00 00       	add    $0x2000,%eax
80100e16:	83 ec 04             	sub    $0x4,%esp
80100e19:	50                   	push   %eax
80100e1a:	ff 75 e0             	pushl  -0x20(%ebp)
80100e1d:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e20:	e8 20 79 00 00       	call   80108745 <allocuvm>
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e2b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100e2f:	0f 84 53 02 00 00    	je     80101088 <exec+0x458>
    goto bad;
  clearpteu(pgdir, (char *)(sz - 2 * PGSIZE));
80100e35:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e38:	2d 00 20 00 00       	sub    $0x2000,%eax
80100e3d:	83 ec 08             	sub    $0x8,%esp
80100e40:	50                   	push   %eax
80100e41:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e44:	e8 6e 7b 00 00       	call   801089b7 <clearpteu>
80100e49:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100e4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e4f:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for (argc = 0; argv[argc]; argc++)
80100e52:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100e59:	e9 96 00 00 00       	jmp    80100ef4 <exec+0x2c4>
  {
    if (argc >= MAXARG)
80100e5e:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100e62:	0f 87 23 02 00 00    	ja     8010108b <exec+0x45b>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e6b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e72:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e75:	01 d0                	add    %edx,%eax
80100e77:	8b 00                	mov    (%eax),%eax
80100e79:	83 ec 0c             	sub    $0xc,%esp
80100e7c:	50                   	push   %eax
80100e7d:	e8 32 4c 00 00       	call   80105ab4 <strlen>
80100e82:	83 c4 10             	add    $0x10,%esp
80100e85:	89 c2                	mov    %eax,%edx
80100e87:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e8a:	29 d0                	sub    %edx,%eax
80100e8c:	83 e8 01             	sub    $0x1,%eax
80100e8f:	83 e0 fc             	and    $0xfffffffc,%eax
80100e92:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e98:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ea2:	01 d0                	add    %edx,%eax
80100ea4:	8b 00                	mov    (%eax),%eax
80100ea6:	83 ec 0c             	sub    $0xc,%esp
80100ea9:	50                   	push   %eax
80100eaa:	e8 05 4c 00 00       	call   80105ab4 <strlen>
80100eaf:	83 c4 10             	add    $0x10,%esp
80100eb2:	83 c0 01             	add    $0x1,%eax
80100eb5:	89 c1                	mov    %eax,%ecx
80100eb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ec4:	01 d0                	add    %edx,%eax
80100ec6:	8b 00                	mov    (%eax),%eax
80100ec8:	51                   	push   %ecx
80100ec9:	50                   	push   %eax
80100eca:	ff 75 dc             	pushl  -0x24(%ebp)
80100ecd:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ed0:	e8 9e 7c 00 00       	call   80108b73 <copyout>
80100ed5:	83 c4 10             	add    $0x10,%esp
80100ed8:	85 c0                	test   %eax,%eax
80100eda:	0f 88 ae 01 00 00    	js     8010108e <exec+0x45e>
      goto bad;
    ustack[3 + argc] = sp;
80100ee0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ee3:	8d 50 03             	lea    0x3(%eax),%edx
80100ee6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ee9:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
  for (argc = 0; argv[argc]; argc++)
80100ef0:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100ef4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ef7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100efe:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f01:	01 d0                	add    %edx,%eax
80100f03:	8b 00                	mov    (%eax),%eax
80100f05:	85 c0                	test   %eax,%eax
80100f07:	0f 85 51 ff ff ff    	jne    80100e5e <exec+0x22e>
  }
  ustack[3 + argc] = 0;
80100f0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f10:	83 c0 03             	add    $0x3,%eax
80100f13:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100f1a:	00 00 00 00 

  ustack[0] = 0xffffffff; // fake return PC
80100f1e:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100f25:	ff ff ff 
  ustack[1] = argc;
80100f28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f2b:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc + 1) * 4; // argv pointer
80100f31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f34:	83 c0 01             	add    $0x1,%eax
80100f37:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f3e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f41:	29 d0                	sub    %edx,%eax
80100f43:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3 + argc + 1) * 4;
80100f49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f4c:	83 c0 04             	add    $0x4,%eax
80100f4f:	c1 e0 02             	shl    $0x2,%eax
80100f52:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0)
80100f55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f58:	83 c0 04             	add    $0x4,%eax
80100f5b:	c1 e0 02             	shl    $0x2,%eax
80100f5e:	50                   	push   %eax
80100f5f:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100f65:	50                   	push   %eax
80100f66:	ff 75 dc             	pushl  -0x24(%ebp)
80100f69:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f6c:	e8 02 7c 00 00       	call   80108b73 <copyout>
80100f71:	83 c4 10             	add    $0x10,%esp
80100f74:	85 c0                	test   %eax,%eax
80100f76:	0f 88 15 01 00 00    	js     80101091 <exec+0x461>
    goto bad;

  // Save program name for debugging.
  for (last = s = path; *s; s++)
80100f7c:	8b 45 08             	mov    0x8(%ebp),%eax
80100f7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f85:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100f88:	eb 17                	jmp    80100fa1 <exec+0x371>
    if (*s == '/')
80100f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f8d:	0f b6 00             	movzbl (%eax),%eax
80100f90:	3c 2f                	cmp    $0x2f,%al
80100f92:	75 09                	jne    80100f9d <exec+0x36d>
      last = s + 1;
80100f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f97:	83 c0 01             	add    $0x1,%eax
80100f9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (last = s = path; *s; s++)
80100f9d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fa4:	0f b6 00             	movzbl (%eax),%eax
80100fa7:	84 c0                	test   %al,%al
80100fa9:	75 df                	jne    80100f8a <exec+0x35a>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100fab:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fae:	83 c0 6c             	add    $0x6c,%eax
80100fb1:	83 ec 04             	sub    $0x4,%esp
80100fb4:	6a 10                	push   $0x10
80100fb6:	ff 75 f0             	pushl  -0x10(%ebp)
80100fb9:	50                   	push   %eax
80100fba:	e8 a7 4a 00 00       	call   80105a66 <safestrcpy>
80100fbf:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100fc2:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fc5:	8b 40 04             	mov    0x4(%eax),%eax
80100fc8:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
80100fcb:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100fd1:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100fd4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100fda:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry; // main
80100fdc:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fdf:	8b 40 18             	mov    0x18(%eax),%eax
80100fe2:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100fe8:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100feb:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fee:	8b 40 18             	mov    0x18(%eax),%eax
80100ff1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ff4:	89 50 44             	mov    %edx,0x44(%eax)

  switchuvm(curproc);
80100ff7:	83 ec 0c             	sub    $0xc,%esp
80100ffa:	ff 75 d0             	pushl  -0x30(%ebp)
80100ffd:	e8 5b 74 00 00       	call   8010845d <switchuvm>
80101002:	83 c4 10             	add    $0x10,%esp

  if (sz % PGSIZE == 0)
80101005:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101008:	25 ff 0f 00 00       	and    $0xfff,%eax
8010100d:	85 c0                	test   %eax,%eax
8010100f:	75 16                	jne    80101027 <exec+0x3f7>
  {
    mencrypt((char *)0, sz / PGSIZE);
80101011:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101014:	c1 e8 0c             	shr    $0xc,%eax
80101017:	83 ec 08             	sub    $0x8,%esp
8010101a:	50                   	push   %eax
8010101b:	6a 00                	push   $0x0
8010101d:	e8 c8 80 00 00       	call   801090ea <mencrypt>
80101022:	83 c4 10             	add    $0x10,%esp
80101025:	eb 17                	jmp    8010103e <exec+0x40e>
  }
  else
  {
    mencrypt((char *)0, sz / PGSIZE + 1);
80101027:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010102a:	c1 e8 0c             	shr    $0xc,%eax
8010102d:	83 c0 01             	add    $0x1,%eax
80101030:	83 ec 08             	sub    $0x8,%esp
80101033:	50                   	push   %eax
80101034:	6a 00                	push   $0x0
80101036:	e8 af 80 00 00       	call   801090ea <mencrypt>
8010103b:	83 c4 10             	add    $0x10,%esp
  }

  curproc->inClock = 0;
8010103e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101041:	c7 80 dc 00 00 00 00 	movl   $0x0,0xdc(%eax)
80101048:	00 00 00 
  curproc->currInd = 0;
8010104b:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010104e:	c7 80 e0 00 00 00 00 	movl   $0x0,0xe0(%eax)
80101055:	00 00 00 
  
  freevm(oldpgdir);
80101058:	83 ec 0c             	sub    $0xc,%esp
8010105b:	ff 75 cc             	pushl  -0x34(%ebp)
8010105e:	e8 b5 78 00 00       	call   80108918 <freevm>
80101063:	83 c4 10             	add    $0x10,%esp


  return 0;
80101066:	b8 00 00 00 00       	mov    $0x0,%eax
8010106b:	eb 57                	jmp    801010c4 <exec+0x494>
    goto bad;
8010106d:	90                   	nop
8010106e:	eb 22                	jmp    80101092 <exec+0x462>
    goto bad;
80101070:	90                   	nop
80101071:	eb 1f                	jmp    80101092 <exec+0x462>
    goto bad;
80101073:	90                   	nop
80101074:	eb 1c                	jmp    80101092 <exec+0x462>
      goto bad;
80101076:	90                   	nop
80101077:	eb 19                	jmp    80101092 <exec+0x462>
      goto bad;
80101079:	90                   	nop
8010107a:	eb 16                	jmp    80101092 <exec+0x462>
      goto bad;
8010107c:	90                   	nop
8010107d:	eb 13                	jmp    80101092 <exec+0x462>
      goto bad;
8010107f:	90                   	nop
80101080:	eb 10                	jmp    80101092 <exec+0x462>
      goto bad;
80101082:	90                   	nop
80101083:	eb 0d                	jmp    80101092 <exec+0x462>
      goto bad;
80101085:	90                   	nop
80101086:	eb 0a                	jmp    80101092 <exec+0x462>
    goto bad;
80101088:	90                   	nop
80101089:	eb 07                	jmp    80101092 <exec+0x462>
      goto bad;
8010108b:	90                   	nop
8010108c:	eb 04                	jmp    80101092 <exec+0x462>
      goto bad;
8010108e:	90                   	nop
8010108f:	eb 01                	jmp    80101092 <exec+0x462>
    goto bad;
80101091:	90                   	nop

bad:
  if (pgdir)
80101092:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80101096:	74 0e                	je     801010a6 <exec+0x476>
    freevm(pgdir);
80101098:	83 ec 0c             	sub    $0xc,%esp
8010109b:	ff 75 d4             	pushl  -0x2c(%ebp)
8010109e:	e8 75 78 00 00       	call   80108918 <freevm>
801010a3:	83 c4 10             	add    $0x10,%esp
  if (ip)
801010a6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
801010aa:	74 13                	je     801010bf <exec+0x48f>
  {
    iunlockput(ip);
801010ac:	83 ec 0c             	sub    $0xc,%esp
801010af:	ff 75 d8             	pushl  -0x28(%ebp)
801010b2:	e8 b4 0c 00 00       	call   80101d6b <iunlockput>
801010b7:	83 c4 10             	add    $0x10,%esp
    end_op();
801010ba:	e8 ce 26 00 00       	call   8010378d <end_op>
  }
  return -1;
801010bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010c4:	c9                   	leave  
801010c5:	c3                   	ret    

801010c6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801010c6:	f3 0f 1e fb          	endbr32 
801010ca:	55                   	push   %ebp
801010cb:	89 e5                	mov    %esp,%ebp
801010cd:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
801010d0:	83 ec 08             	sub    $0x8,%esp
801010d3:	68 a1 98 10 80       	push   $0x801098a1
801010d8:	68 60 30 11 80       	push   $0x80113060
801010dd:	e8 a4 44 00 00       	call   80105586 <initlock>
801010e2:	83 c4 10             	add    $0x10,%esp
}
801010e5:	90                   	nop
801010e6:	c9                   	leave  
801010e7:	c3                   	ret    

801010e8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801010e8:	f3 0f 1e fb          	endbr32 
801010ec:	55                   	push   %ebp
801010ed:	89 e5                	mov    %esp,%ebp
801010ef:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 60 30 11 80       	push   $0x80113060
801010fa:	e8 ad 44 00 00       	call   801055ac <acquire>
801010ff:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101102:	c7 45 f4 94 30 11 80 	movl   $0x80113094,-0xc(%ebp)
80101109:	eb 2d                	jmp    80101138 <filealloc+0x50>
    if(f->ref == 0){
8010110b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010110e:	8b 40 04             	mov    0x4(%eax),%eax
80101111:	85 c0                	test   %eax,%eax
80101113:	75 1f                	jne    80101134 <filealloc+0x4c>
      f->ref = 1;
80101115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101118:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	68 60 30 11 80       	push   $0x80113060
80101127:	e8 f2 44 00 00       	call   8010561e <release>
8010112c:	83 c4 10             	add    $0x10,%esp
      return f;
8010112f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101132:	eb 23                	jmp    80101157 <filealloc+0x6f>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101134:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101138:	b8 f4 39 11 80       	mov    $0x801139f4,%eax
8010113d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101140:	72 c9                	jb     8010110b <filealloc+0x23>
    }
  }
  release(&ftable.lock);
80101142:	83 ec 0c             	sub    $0xc,%esp
80101145:	68 60 30 11 80       	push   $0x80113060
8010114a:	e8 cf 44 00 00       	call   8010561e <release>
8010114f:	83 c4 10             	add    $0x10,%esp
  return 0;
80101152:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101157:	c9                   	leave  
80101158:	c3                   	ret    

80101159 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101159:	f3 0f 1e fb          	endbr32 
8010115d:	55                   	push   %ebp
8010115e:	89 e5                	mov    %esp,%ebp
80101160:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101163:	83 ec 0c             	sub    $0xc,%esp
80101166:	68 60 30 11 80       	push   $0x80113060
8010116b:	e8 3c 44 00 00       	call   801055ac <acquire>
80101170:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101173:	8b 45 08             	mov    0x8(%ebp),%eax
80101176:	8b 40 04             	mov    0x4(%eax),%eax
80101179:	85 c0                	test   %eax,%eax
8010117b:	7f 0d                	jg     8010118a <filedup+0x31>
    panic("filedup");
8010117d:	83 ec 0c             	sub    $0xc,%esp
80101180:	68 a8 98 10 80       	push   $0x801098a8
80101185:	e8 7e f4 ff ff       	call   80100608 <panic>
  f->ref++;
8010118a:	8b 45 08             	mov    0x8(%ebp),%eax
8010118d:	8b 40 04             	mov    0x4(%eax),%eax
80101190:	8d 50 01             	lea    0x1(%eax),%edx
80101193:	8b 45 08             	mov    0x8(%ebp),%eax
80101196:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101199:	83 ec 0c             	sub    $0xc,%esp
8010119c:	68 60 30 11 80       	push   $0x80113060
801011a1:	e8 78 44 00 00       	call   8010561e <release>
801011a6:	83 c4 10             	add    $0x10,%esp
  return f;
801011a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
801011ac:	c9                   	leave  
801011ad:	c3                   	ret    

801011ae <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801011ae:	f3 0f 1e fb          	endbr32 
801011b2:	55                   	push   %ebp
801011b3:	89 e5                	mov    %esp,%ebp
801011b5:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801011b8:	83 ec 0c             	sub    $0xc,%esp
801011bb:	68 60 30 11 80       	push   $0x80113060
801011c0:	e8 e7 43 00 00       	call   801055ac <acquire>
801011c5:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801011c8:	8b 45 08             	mov    0x8(%ebp),%eax
801011cb:	8b 40 04             	mov    0x4(%eax),%eax
801011ce:	85 c0                	test   %eax,%eax
801011d0:	7f 0d                	jg     801011df <fileclose+0x31>
    panic("fileclose");
801011d2:	83 ec 0c             	sub    $0xc,%esp
801011d5:	68 b0 98 10 80       	push   $0x801098b0
801011da:	e8 29 f4 ff ff       	call   80100608 <panic>
  if(--f->ref > 0){
801011df:	8b 45 08             	mov    0x8(%ebp),%eax
801011e2:	8b 40 04             	mov    0x4(%eax),%eax
801011e5:	8d 50 ff             	lea    -0x1(%eax),%edx
801011e8:	8b 45 08             	mov    0x8(%ebp),%eax
801011eb:	89 50 04             	mov    %edx,0x4(%eax)
801011ee:	8b 45 08             	mov    0x8(%ebp),%eax
801011f1:	8b 40 04             	mov    0x4(%eax),%eax
801011f4:	85 c0                	test   %eax,%eax
801011f6:	7e 15                	jle    8010120d <fileclose+0x5f>
    release(&ftable.lock);
801011f8:	83 ec 0c             	sub    $0xc,%esp
801011fb:	68 60 30 11 80       	push   $0x80113060
80101200:	e8 19 44 00 00       	call   8010561e <release>
80101205:	83 c4 10             	add    $0x10,%esp
80101208:	e9 8b 00 00 00       	jmp    80101298 <fileclose+0xea>
    return;
  }
  ff = *f;
8010120d:	8b 45 08             	mov    0x8(%ebp),%eax
80101210:	8b 10                	mov    (%eax),%edx
80101212:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101215:	8b 50 04             	mov    0x4(%eax),%edx
80101218:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010121b:	8b 50 08             	mov    0x8(%eax),%edx
8010121e:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101221:	8b 50 0c             	mov    0xc(%eax),%edx
80101224:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101227:	8b 50 10             	mov    0x10(%eax),%edx
8010122a:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010122d:	8b 40 14             	mov    0x14(%eax),%eax
80101230:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101233:	8b 45 08             	mov    0x8(%ebp),%eax
80101236:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010123d:	8b 45 08             	mov    0x8(%ebp),%eax
80101240:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101246:	83 ec 0c             	sub    $0xc,%esp
80101249:	68 60 30 11 80       	push   $0x80113060
8010124e:	e8 cb 43 00 00       	call   8010561e <release>
80101253:	83 c4 10             	add    $0x10,%esp

  if(ff.type == FD_PIPE)
80101256:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101259:	83 f8 01             	cmp    $0x1,%eax
8010125c:	75 19                	jne    80101277 <fileclose+0xc9>
    pipeclose(ff.pipe, ff.writable);
8010125e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101262:	0f be d0             	movsbl %al,%edx
80101265:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101268:	83 ec 08             	sub    $0x8,%esp
8010126b:	52                   	push   %edx
8010126c:	50                   	push   %eax
8010126d:	e8 c1 2e 00 00       	call   80104133 <pipeclose>
80101272:	83 c4 10             	add    $0x10,%esp
80101275:	eb 21                	jmp    80101298 <fileclose+0xea>
  else if(ff.type == FD_INODE){
80101277:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010127a:	83 f8 02             	cmp    $0x2,%eax
8010127d:	75 19                	jne    80101298 <fileclose+0xea>
    begin_op();
8010127f:	e8 79 24 00 00       	call   801036fd <begin_op>
    iput(ff.ip);
80101284:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101287:	83 ec 0c             	sub    $0xc,%esp
8010128a:	50                   	push   %eax
8010128b:	e8 07 0a 00 00       	call   80101c97 <iput>
80101290:	83 c4 10             	add    $0x10,%esp
    end_op();
80101293:	e8 f5 24 00 00       	call   8010378d <end_op>
  }
}
80101298:	c9                   	leave  
80101299:	c3                   	ret    

8010129a <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
8010129a:	f3 0f 1e fb          	endbr32 
8010129e:	55                   	push   %ebp
8010129f:	89 e5                	mov    %esp,%ebp
801012a1:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801012a4:	8b 45 08             	mov    0x8(%ebp),%eax
801012a7:	8b 00                	mov    (%eax),%eax
801012a9:	83 f8 02             	cmp    $0x2,%eax
801012ac:	75 40                	jne    801012ee <filestat+0x54>
    ilock(f->ip);
801012ae:	8b 45 08             	mov    0x8(%ebp),%eax
801012b1:	8b 40 10             	mov    0x10(%eax),%eax
801012b4:	83 ec 0c             	sub    $0xc,%esp
801012b7:	50                   	push   %eax
801012b8:	e8 71 08 00 00       	call   80101b2e <ilock>
801012bd:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801012c0:	8b 45 08             	mov    0x8(%ebp),%eax
801012c3:	8b 40 10             	mov    0x10(%eax),%eax
801012c6:	83 ec 08             	sub    $0x8,%esp
801012c9:	ff 75 0c             	pushl  0xc(%ebp)
801012cc:	50                   	push   %eax
801012cd:	e8 1a 0d 00 00       	call   80101fec <stati>
801012d2:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
801012d5:	8b 45 08             	mov    0x8(%ebp),%eax
801012d8:	8b 40 10             	mov    0x10(%eax),%eax
801012db:	83 ec 0c             	sub    $0xc,%esp
801012de:	50                   	push   %eax
801012df:	e8 61 09 00 00       	call   80101c45 <iunlock>
801012e4:	83 c4 10             	add    $0x10,%esp
    return 0;
801012e7:	b8 00 00 00 00       	mov    $0x0,%eax
801012ec:	eb 05                	jmp    801012f3 <filestat+0x59>
  }
  return -1;
801012ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801012f3:	c9                   	leave  
801012f4:	c3                   	ret    

801012f5 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801012f5:	f3 0f 1e fb          	endbr32 
801012f9:	55                   	push   %ebp
801012fa:	89 e5                	mov    %esp,%ebp
801012fc:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801012ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101302:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101306:	84 c0                	test   %al,%al
80101308:	75 0a                	jne    80101314 <fileread+0x1f>
    return -1;
8010130a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010130f:	e9 9b 00 00 00       	jmp    801013af <fileread+0xba>
  if(f->type == FD_PIPE)
80101314:	8b 45 08             	mov    0x8(%ebp),%eax
80101317:	8b 00                	mov    (%eax),%eax
80101319:	83 f8 01             	cmp    $0x1,%eax
8010131c:	75 1a                	jne    80101338 <fileread+0x43>
    return piperead(f->pipe, addr, n);
8010131e:	8b 45 08             	mov    0x8(%ebp),%eax
80101321:	8b 40 0c             	mov    0xc(%eax),%eax
80101324:	83 ec 04             	sub    $0x4,%esp
80101327:	ff 75 10             	pushl  0x10(%ebp)
8010132a:	ff 75 0c             	pushl  0xc(%ebp)
8010132d:	50                   	push   %eax
8010132e:	e8 b5 2f 00 00       	call   801042e8 <piperead>
80101333:	83 c4 10             	add    $0x10,%esp
80101336:	eb 77                	jmp    801013af <fileread+0xba>
  if(f->type == FD_INODE){
80101338:	8b 45 08             	mov    0x8(%ebp),%eax
8010133b:	8b 00                	mov    (%eax),%eax
8010133d:	83 f8 02             	cmp    $0x2,%eax
80101340:	75 60                	jne    801013a2 <fileread+0xad>
    ilock(f->ip);
80101342:	8b 45 08             	mov    0x8(%ebp),%eax
80101345:	8b 40 10             	mov    0x10(%eax),%eax
80101348:	83 ec 0c             	sub    $0xc,%esp
8010134b:	50                   	push   %eax
8010134c:	e8 dd 07 00 00       	call   80101b2e <ilock>
80101351:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101354:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101357:	8b 45 08             	mov    0x8(%ebp),%eax
8010135a:	8b 50 14             	mov    0x14(%eax),%edx
8010135d:	8b 45 08             	mov    0x8(%ebp),%eax
80101360:	8b 40 10             	mov    0x10(%eax),%eax
80101363:	51                   	push   %ecx
80101364:	52                   	push   %edx
80101365:	ff 75 0c             	pushl  0xc(%ebp)
80101368:	50                   	push   %eax
80101369:	e8 c8 0c 00 00       	call   80102036 <readi>
8010136e:	83 c4 10             	add    $0x10,%esp
80101371:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101374:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101378:	7e 11                	jle    8010138b <fileread+0x96>
      f->off += r;
8010137a:	8b 45 08             	mov    0x8(%ebp),%eax
8010137d:	8b 50 14             	mov    0x14(%eax),%edx
80101380:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101383:	01 c2                	add    %eax,%edx
80101385:	8b 45 08             	mov    0x8(%ebp),%eax
80101388:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
8010138b:	8b 45 08             	mov    0x8(%ebp),%eax
8010138e:	8b 40 10             	mov    0x10(%eax),%eax
80101391:	83 ec 0c             	sub    $0xc,%esp
80101394:	50                   	push   %eax
80101395:	e8 ab 08 00 00       	call   80101c45 <iunlock>
8010139a:	83 c4 10             	add    $0x10,%esp
    return r;
8010139d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a0:	eb 0d                	jmp    801013af <fileread+0xba>
  }
  panic("fileread");
801013a2:	83 ec 0c             	sub    $0xc,%esp
801013a5:	68 ba 98 10 80       	push   $0x801098ba
801013aa:	e8 59 f2 ff ff       	call   80100608 <panic>
}
801013af:	c9                   	leave  
801013b0:	c3                   	ret    

801013b1 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801013b1:	f3 0f 1e fb          	endbr32 
801013b5:	55                   	push   %ebp
801013b6:	89 e5                	mov    %esp,%ebp
801013b8:	53                   	push   %ebx
801013b9:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801013bc:	8b 45 08             	mov    0x8(%ebp),%eax
801013bf:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801013c3:	84 c0                	test   %al,%al
801013c5:	75 0a                	jne    801013d1 <filewrite+0x20>
    return -1;
801013c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013cc:	e9 1b 01 00 00       	jmp    801014ec <filewrite+0x13b>
  if(f->type == FD_PIPE)
801013d1:	8b 45 08             	mov    0x8(%ebp),%eax
801013d4:	8b 00                	mov    (%eax),%eax
801013d6:	83 f8 01             	cmp    $0x1,%eax
801013d9:	75 1d                	jne    801013f8 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801013db:	8b 45 08             	mov    0x8(%ebp),%eax
801013de:	8b 40 0c             	mov    0xc(%eax),%eax
801013e1:	83 ec 04             	sub    $0x4,%esp
801013e4:	ff 75 10             	pushl  0x10(%ebp)
801013e7:	ff 75 0c             	pushl  0xc(%ebp)
801013ea:	50                   	push   %eax
801013eb:	e8 f2 2d 00 00       	call   801041e2 <pipewrite>
801013f0:	83 c4 10             	add    $0x10,%esp
801013f3:	e9 f4 00 00 00       	jmp    801014ec <filewrite+0x13b>
  if(f->type == FD_INODE){
801013f8:	8b 45 08             	mov    0x8(%ebp),%eax
801013fb:	8b 00                	mov    (%eax),%eax
801013fd:	83 f8 02             	cmp    $0x2,%eax
80101400:	0f 85 d9 00 00 00    	jne    801014df <filewrite+0x12e>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
80101406:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
8010140d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101414:	e9 a3 00 00 00       	jmp    801014bc <filewrite+0x10b>
      int n1 = n - i;
80101419:	8b 45 10             	mov    0x10(%ebp),%eax
8010141c:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010141f:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101422:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101425:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101428:	7e 06                	jle    80101430 <filewrite+0x7f>
        n1 = max;
8010142a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010142d:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101430:	e8 c8 22 00 00       	call   801036fd <begin_op>
      ilock(f->ip);
80101435:	8b 45 08             	mov    0x8(%ebp),%eax
80101438:	8b 40 10             	mov    0x10(%eax),%eax
8010143b:	83 ec 0c             	sub    $0xc,%esp
8010143e:	50                   	push   %eax
8010143f:	e8 ea 06 00 00       	call   80101b2e <ilock>
80101444:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101447:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010144a:	8b 45 08             	mov    0x8(%ebp),%eax
8010144d:	8b 50 14             	mov    0x14(%eax),%edx
80101450:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101453:	8b 45 0c             	mov    0xc(%ebp),%eax
80101456:	01 c3                	add    %eax,%ebx
80101458:	8b 45 08             	mov    0x8(%ebp),%eax
8010145b:	8b 40 10             	mov    0x10(%eax),%eax
8010145e:	51                   	push   %ecx
8010145f:	52                   	push   %edx
80101460:	53                   	push   %ebx
80101461:	50                   	push   %eax
80101462:	e8 28 0d 00 00       	call   8010218f <writei>
80101467:	83 c4 10             	add    $0x10,%esp
8010146a:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010146d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101471:	7e 11                	jle    80101484 <filewrite+0xd3>
        f->off += r;
80101473:	8b 45 08             	mov    0x8(%ebp),%eax
80101476:	8b 50 14             	mov    0x14(%eax),%edx
80101479:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010147c:	01 c2                	add    %eax,%edx
8010147e:	8b 45 08             	mov    0x8(%ebp),%eax
80101481:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101484:	8b 45 08             	mov    0x8(%ebp),%eax
80101487:	8b 40 10             	mov    0x10(%eax),%eax
8010148a:	83 ec 0c             	sub    $0xc,%esp
8010148d:	50                   	push   %eax
8010148e:	e8 b2 07 00 00       	call   80101c45 <iunlock>
80101493:	83 c4 10             	add    $0x10,%esp
      end_op();
80101496:	e8 f2 22 00 00       	call   8010378d <end_op>

      if(r < 0)
8010149b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010149f:	78 29                	js     801014ca <filewrite+0x119>
        break;
      if(r != n1)
801014a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801014a4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801014a7:	74 0d                	je     801014b6 <filewrite+0x105>
        panic("short filewrite");
801014a9:	83 ec 0c             	sub    $0xc,%esp
801014ac:	68 c3 98 10 80       	push   $0x801098c3
801014b1:	e8 52 f1 ff ff       	call   80100608 <panic>
      i += r;
801014b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801014b9:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
801014bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014bf:	3b 45 10             	cmp    0x10(%ebp),%eax
801014c2:	0f 8c 51 ff ff ff    	jl     80101419 <filewrite+0x68>
801014c8:	eb 01                	jmp    801014cb <filewrite+0x11a>
        break;
801014ca:	90                   	nop
    }
    return i == n ? n : -1;
801014cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014ce:	3b 45 10             	cmp    0x10(%ebp),%eax
801014d1:	75 05                	jne    801014d8 <filewrite+0x127>
801014d3:	8b 45 10             	mov    0x10(%ebp),%eax
801014d6:	eb 14                	jmp    801014ec <filewrite+0x13b>
801014d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801014dd:	eb 0d                	jmp    801014ec <filewrite+0x13b>
  }
  panic("filewrite");
801014df:	83 ec 0c             	sub    $0xc,%esp
801014e2:	68 d3 98 10 80       	push   $0x801098d3
801014e7:	e8 1c f1 ff ff       	call   80100608 <panic>
}
801014ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014ef:	c9                   	leave  
801014f0:	c3                   	ret    

801014f1 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801014f1:	f3 0f 1e fb          	endbr32 
801014f5:	55                   	push   %ebp
801014f6:	89 e5                	mov    %esp,%ebp
801014f8:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801014fb:	8b 45 08             	mov    0x8(%ebp),%eax
801014fe:	83 ec 08             	sub    $0x8,%esp
80101501:	6a 01                	push   $0x1
80101503:	50                   	push   %eax
80101504:	e8 ce ec ff ff       	call   801001d7 <bread>
80101509:	83 c4 10             	add    $0x10,%esp
8010150c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010150f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101512:	83 c0 5c             	add    $0x5c,%eax
80101515:	83 ec 04             	sub    $0x4,%esp
80101518:	6a 1c                	push   $0x1c
8010151a:	50                   	push   %eax
8010151b:	ff 75 0c             	pushl  0xc(%ebp)
8010151e:	e8 ef 43 00 00       	call   80105912 <memmove>
80101523:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101526:	83 ec 0c             	sub    $0xc,%esp
80101529:	ff 75 f4             	pushl  -0xc(%ebp)
8010152c:	e8 30 ed ff ff       	call   80100261 <brelse>
80101531:	83 c4 10             	add    $0x10,%esp
}
80101534:	90                   	nop
80101535:	c9                   	leave  
80101536:	c3                   	ret    

80101537 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101537:	f3 0f 1e fb          	endbr32 
8010153b:	55                   	push   %ebp
8010153c:	89 e5                	mov    %esp,%ebp
8010153e:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, bno);
80101541:	8b 55 0c             	mov    0xc(%ebp),%edx
80101544:	8b 45 08             	mov    0x8(%ebp),%eax
80101547:	83 ec 08             	sub    $0x8,%esp
8010154a:	52                   	push   %edx
8010154b:	50                   	push   %eax
8010154c:	e8 86 ec ff ff       	call   801001d7 <bread>
80101551:	83 c4 10             	add    $0x10,%esp
80101554:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101557:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010155a:	83 c0 5c             	add    $0x5c,%eax
8010155d:	83 ec 04             	sub    $0x4,%esp
80101560:	68 00 02 00 00       	push   $0x200
80101565:	6a 00                	push   $0x0
80101567:	50                   	push   %eax
80101568:	e8 de 42 00 00       	call   8010584b <memset>
8010156d:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101570:	83 ec 0c             	sub    $0xc,%esp
80101573:	ff 75 f4             	pushl  -0xc(%ebp)
80101576:	e8 cb 23 00 00       	call   80103946 <log_write>
8010157b:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010157e:	83 ec 0c             	sub    $0xc,%esp
80101581:	ff 75 f4             	pushl  -0xc(%ebp)
80101584:	e8 d8 ec ff ff       	call   80100261 <brelse>
80101589:	83 c4 10             	add    $0x10,%esp
}
8010158c:	90                   	nop
8010158d:	c9                   	leave  
8010158e:	c3                   	ret    

8010158f <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010158f:	f3 0f 1e fb          	endbr32 
80101593:	55                   	push   %ebp
80101594:	89 e5                	mov    %esp,%ebp
80101596:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101599:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801015a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801015a7:	e9 13 01 00 00       	jmp    801016bf <balloc+0x130>
    bp = bread(dev, BBLOCK(b, sb));
801015ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015af:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801015b5:	85 c0                	test   %eax,%eax
801015b7:	0f 48 c2             	cmovs  %edx,%eax
801015ba:	c1 f8 0c             	sar    $0xc,%eax
801015bd:	89 c2                	mov    %eax,%edx
801015bf:	a1 78 3a 11 80       	mov    0x80113a78,%eax
801015c4:	01 d0                	add    %edx,%eax
801015c6:	83 ec 08             	sub    $0x8,%esp
801015c9:	50                   	push   %eax
801015ca:	ff 75 08             	pushl  0x8(%ebp)
801015cd:	e8 05 ec ff ff       	call   801001d7 <bread>
801015d2:	83 c4 10             	add    $0x10,%esp
801015d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801015df:	e9 a6 00 00 00       	jmp    8010168a <balloc+0xfb>
      m = 1 << (bi % 8);
801015e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015e7:	99                   	cltd   
801015e8:	c1 ea 1d             	shr    $0x1d,%edx
801015eb:	01 d0                	add    %edx,%eax
801015ed:	83 e0 07             	and    $0x7,%eax
801015f0:	29 d0                	sub    %edx,%eax
801015f2:	ba 01 00 00 00       	mov    $0x1,%edx
801015f7:	89 c1                	mov    %eax,%ecx
801015f9:	d3 e2                	shl    %cl,%edx
801015fb:	89 d0                	mov    %edx,%eax
801015fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101600:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101603:	8d 50 07             	lea    0x7(%eax),%edx
80101606:	85 c0                	test   %eax,%eax
80101608:	0f 48 c2             	cmovs  %edx,%eax
8010160b:	c1 f8 03             	sar    $0x3,%eax
8010160e:	89 c2                	mov    %eax,%edx
80101610:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101613:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101618:	0f b6 c0             	movzbl %al,%eax
8010161b:	23 45 e8             	and    -0x18(%ebp),%eax
8010161e:	85 c0                	test   %eax,%eax
80101620:	75 64                	jne    80101686 <balloc+0xf7>
        bp->data[bi/8] |= m;  // Mark block in use.
80101622:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101625:	8d 50 07             	lea    0x7(%eax),%edx
80101628:	85 c0                	test   %eax,%eax
8010162a:	0f 48 c2             	cmovs  %edx,%eax
8010162d:	c1 f8 03             	sar    $0x3,%eax
80101630:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101633:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101638:	89 d1                	mov    %edx,%ecx
8010163a:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010163d:	09 ca                	or     %ecx,%edx
8010163f:	89 d1                	mov    %edx,%ecx
80101641:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101644:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
80101648:	83 ec 0c             	sub    $0xc,%esp
8010164b:	ff 75 ec             	pushl  -0x14(%ebp)
8010164e:	e8 f3 22 00 00       	call   80103946 <log_write>
80101653:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101656:	83 ec 0c             	sub    $0xc,%esp
80101659:	ff 75 ec             	pushl  -0x14(%ebp)
8010165c:	e8 00 ec ff ff       	call   80100261 <brelse>
80101661:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101664:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101667:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010166a:	01 c2                	add    %eax,%edx
8010166c:	8b 45 08             	mov    0x8(%ebp),%eax
8010166f:	83 ec 08             	sub    $0x8,%esp
80101672:	52                   	push   %edx
80101673:	50                   	push   %eax
80101674:	e8 be fe ff ff       	call   80101537 <bzero>
80101679:	83 c4 10             	add    $0x10,%esp
        return b + bi;
8010167c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010167f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101682:	01 d0                	add    %edx,%eax
80101684:	eb 57                	jmp    801016dd <balloc+0x14e>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101686:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010168a:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101691:	7f 17                	jg     801016aa <balloc+0x11b>
80101693:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101696:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101699:	01 d0                	add    %edx,%eax
8010169b:	89 c2                	mov    %eax,%edx
8010169d:	a1 60 3a 11 80       	mov    0x80113a60,%eax
801016a2:	39 c2                	cmp    %eax,%edx
801016a4:	0f 82 3a ff ff ff    	jb     801015e4 <balloc+0x55>
      }
    }
    brelse(bp);
801016aa:	83 ec 0c             	sub    $0xc,%esp
801016ad:	ff 75 ec             	pushl  -0x14(%ebp)
801016b0:	e8 ac eb ff ff       	call   80100261 <brelse>
801016b5:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
801016b8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801016bf:	8b 15 60 3a 11 80    	mov    0x80113a60,%edx
801016c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016c8:	39 c2                	cmp    %eax,%edx
801016ca:	0f 87 dc fe ff ff    	ja     801015ac <balloc+0x1d>
  }
  panic("balloc: out of blocks");
801016d0:	83 ec 0c             	sub    $0xc,%esp
801016d3:	68 e0 98 10 80       	push   $0x801098e0
801016d8:	e8 2b ef ff ff       	call   80100608 <panic>
}
801016dd:	c9                   	leave  
801016de:	c3                   	ret    

801016df <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801016df:	f3 0f 1e fb          	endbr32 
801016e3:	55                   	push   %ebp
801016e4:	89 e5                	mov    %esp,%ebp
801016e6:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801016e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801016ec:	c1 e8 0c             	shr    $0xc,%eax
801016ef:	89 c2                	mov    %eax,%edx
801016f1:	a1 78 3a 11 80       	mov    0x80113a78,%eax
801016f6:	01 c2                	add    %eax,%edx
801016f8:	8b 45 08             	mov    0x8(%ebp),%eax
801016fb:	83 ec 08             	sub    $0x8,%esp
801016fe:	52                   	push   %edx
801016ff:	50                   	push   %eax
80101700:	e8 d2 ea ff ff       	call   801001d7 <bread>
80101705:	83 c4 10             	add    $0x10,%esp
80101708:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
8010170b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010170e:	25 ff 0f 00 00       	and    $0xfff,%eax
80101713:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101716:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101719:	99                   	cltd   
8010171a:	c1 ea 1d             	shr    $0x1d,%edx
8010171d:	01 d0                	add    %edx,%eax
8010171f:	83 e0 07             	and    $0x7,%eax
80101722:	29 d0                	sub    %edx,%eax
80101724:	ba 01 00 00 00       	mov    $0x1,%edx
80101729:	89 c1                	mov    %eax,%ecx
8010172b:	d3 e2                	shl    %cl,%edx
8010172d:	89 d0                	mov    %edx,%eax
8010172f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101732:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101735:	8d 50 07             	lea    0x7(%eax),%edx
80101738:	85 c0                	test   %eax,%eax
8010173a:	0f 48 c2             	cmovs  %edx,%eax
8010173d:	c1 f8 03             	sar    $0x3,%eax
80101740:	89 c2                	mov    %eax,%edx
80101742:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101745:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
8010174a:	0f b6 c0             	movzbl %al,%eax
8010174d:	23 45 ec             	and    -0x14(%ebp),%eax
80101750:	85 c0                	test   %eax,%eax
80101752:	75 0d                	jne    80101761 <bfree+0x82>
    panic("freeing free block");
80101754:	83 ec 0c             	sub    $0xc,%esp
80101757:	68 f6 98 10 80       	push   $0x801098f6
8010175c:	e8 a7 ee ff ff       	call   80100608 <panic>
  bp->data[bi/8] &= ~m;
80101761:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101764:	8d 50 07             	lea    0x7(%eax),%edx
80101767:	85 c0                	test   %eax,%eax
80101769:	0f 48 c2             	cmovs  %edx,%eax
8010176c:	c1 f8 03             	sar    $0x3,%eax
8010176f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101772:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101777:	89 d1                	mov    %edx,%ecx
80101779:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010177c:	f7 d2                	not    %edx
8010177e:	21 ca                	and    %ecx,%edx
80101780:	89 d1                	mov    %edx,%ecx
80101782:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101785:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
80101789:	83 ec 0c             	sub    $0xc,%esp
8010178c:	ff 75 f4             	pushl  -0xc(%ebp)
8010178f:	e8 b2 21 00 00       	call   80103946 <log_write>
80101794:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101797:	83 ec 0c             	sub    $0xc,%esp
8010179a:	ff 75 f4             	pushl  -0xc(%ebp)
8010179d:	e8 bf ea ff ff       	call   80100261 <brelse>
801017a2:	83 c4 10             	add    $0x10,%esp
}
801017a5:	90                   	nop
801017a6:	c9                   	leave  
801017a7:	c3                   	ret    

801017a8 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801017a8:	f3 0f 1e fb          	endbr32 
801017ac:	55                   	push   %ebp
801017ad:	89 e5                	mov    %esp,%ebp
801017af:	57                   	push   %edi
801017b0:	56                   	push   %esi
801017b1:	53                   	push   %ebx
801017b2:	83 ec 2c             	sub    $0x2c,%esp
  int i = 0;
801017b5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
801017bc:	83 ec 08             	sub    $0x8,%esp
801017bf:	68 09 99 10 80       	push   $0x80109909
801017c4:	68 80 3a 11 80       	push   $0x80113a80
801017c9:	e8 b8 3d 00 00       	call   80105586 <initlock>
801017ce:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801017d1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801017d8:	eb 2d                	jmp    80101807 <iinit+0x5f>
    initsleeplock(&icache.inode[i].lock, "inode");
801017da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801017dd:	89 d0                	mov    %edx,%eax
801017df:	c1 e0 03             	shl    $0x3,%eax
801017e2:	01 d0                	add    %edx,%eax
801017e4:	c1 e0 04             	shl    $0x4,%eax
801017e7:	83 c0 30             	add    $0x30,%eax
801017ea:	05 80 3a 11 80       	add    $0x80113a80,%eax
801017ef:	83 c0 10             	add    $0x10,%eax
801017f2:	83 ec 08             	sub    $0x8,%esp
801017f5:	68 10 99 10 80       	push   $0x80109910
801017fa:	50                   	push   %eax
801017fb:	e8 f3 3b 00 00       	call   801053f3 <initsleeplock>
80101800:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
80101803:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80101807:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
8010180b:	7e cd                	jle    801017da <iinit+0x32>
  }

  readsb(dev, &sb);
8010180d:	83 ec 08             	sub    $0x8,%esp
80101810:	68 60 3a 11 80       	push   $0x80113a60
80101815:	ff 75 08             	pushl  0x8(%ebp)
80101818:	e8 d4 fc ff ff       	call   801014f1 <readsb>
8010181d:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101820:	a1 78 3a 11 80       	mov    0x80113a78,%eax
80101825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80101828:	8b 3d 74 3a 11 80    	mov    0x80113a74,%edi
8010182e:	8b 35 70 3a 11 80    	mov    0x80113a70,%esi
80101834:	8b 1d 6c 3a 11 80    	mov    0x80113a6c,%ebx
8010183a:	8b 0d 68 3a 11 80    	mov    0x80113a68,%ecx
80101840:	8b 15 64 3a 11 80    	mov    0x80113a64,%edx
80101846:	a1 60 3a 11 80       	mov    0x80113a60,%eax
8010184b:	ff 75 d4             	pushl  -0x2c(%ebp)
8010184e:	57                   	push   %edi
8010184f:	56                   	push   %esi
80101850:	53                   	push   %ebx
80101851:	51                   	push   %ecx
80101852:	52                   	push   %edx
80101853:	50                   	push   %eax
80101854:	68 18 99 10 80       	push   $0x80109918
80101859:	e8 ba eb ff ff       	call   80100418 <cprintf>
8010185e:	83 c4 20             	add    $0x20,%esp
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101861:	90                   	nop
80101862:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101865:	5b                   	pop    %ebx
80101866:	5e                   	pop    %esi
80101867:	5f                   	pop    %edi
80101868:	5d                   	pop    %ebp
80101869:	c3                   	ret    

8010186a <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
8010186a:	f3 0f 1e fb          	endbr32 
8010186e:	55                   	push   %ebp
8010186f:	89 e5                	mov    %esp,%ebp
80101871:	83 ec 28             	sub    $0x28,%esp
80101874:	8b 45 0c             	mov    0xc(%ebp),%eax
80101877:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010187b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101882:	e9 9e 00 00 00       	jmp    80101925 <ialloc+0xbb>
    bp = bread(dev, IBLOCK(inum, sb));
80101887:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010188a:	c1 e8 03             	shr    $0x3,%eax
8010188d:	89 c2                	mov    %eax,%edx
8010188f:	a1 74 3a 11 80       	mov    0x80113a74,%eax
80101894:	01 d0                	add    %edx,%eax
80101896:	83 ec 08             	sub    $0x8,%esp
80101899:	50                   	push   %eax
8010189a:	ff 75 08             	pushl  0x8(%ebp)
8010189d:	e8 35 e9 ff ff       	call   801001d7 <bread>
801018a2:	83 c4 10             	add    $0x10,%esp
801018a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801018a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018ab:	8d 50 5c             	lea    0x5c(%eax),%edx
801018ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b1:	83 e0 07             	and    $0x7,%eax
801018b4:	c1 e0 06             	shl    $0x6,%eax
801018b7:	01 d0                	add    %edx,%eax
801018b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801018bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801018bf:	0f b7 00             	movzwl (%eax),%eax
801018c2:	66 85 c0             	test   %ax,%ax
801018c5:	75 4c                	jne    80101913 <ialloc+0xa9>
      memset(dip, 0, sizeof(*dip));
801018c7:	83 ec 04             	sub    $0x4,%esp
801018ca:	6a 40                	push   $0x40
801018cc:	6a 00                	push   $0x0
801018ce:	ff 75 ec             	pushl  -0x14(%ebp)
801018d1:	e8 75 3f 00 00       	call   8010584b <memset>
801018d6:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801018d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801018dc:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801018e0:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801018e3:	83 ec 0c             	sub    $0xc,%esp
801018e6:	ff 75 f0             	pushl  -0x10(%ebp)
801018e9:	e8 58 20 00 00       	call   80103946 <log_write>
801018ee:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801018f1:	83 ec 0c             	sub    $0xc,%esp
801018f4:	ff 75 f0             	pushl  -0x10(%ebp)
801018f7:	e8 65 e9 ff ff       	call   80100261 <brelse>
801018fc:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801018ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101902:	83 ec 08             	sub    $0x8,%esp
80101905:	50                   	push   %eax
80101906:	ff 75 08             	pushl  0x8(%ebp)
80101909:	e8 fc 00 00 00       	call   80101a0a <iget>
8010190e:	83 c4 10             	add    $0x10,%esp
80101911:	eb 30                	jmp    80101943 <ialloc+0xd9>
    }
    brelse(bp);
80101913:	83 ec 0c             	sub    $0xc,%esp
80101916:	ff 75 f0             	pushl  -0x10(%ebp)
80101919:	e8 43 e9 ff ff       	call   80100261 <brelse>
8010191e:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101921:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101925:	8b 15 68 3a 11 80    	mov    0x80113a68,%edx
8010192b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010192e:	39 c2                	cmp    %eax,%edx
80101930:	0f 87 51 ff ff ff    	ja     80101887 <ialloc+0x1d>
  }
  panic("ialloc: no inodes");
80101936:	83 ec 0c             	sub    $0xc,%esp
80101939:	68 6b 99 10 80       	push   $0x8010996b
8010193e:	e8 c5 ec ff ff       	call   80100608 <panic>
}
80101943:	c9                   	leave  
80101944:	c3                   	ret    

80101945 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101945:	f3 0f 1e fb          	endbr32 
80101949:	55                   	push   %ebp
8010194a:	89 e5                	mov    %esp,%ebp
8010194c:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010194f:	8b 45 08             	mov    0x8(%ebp),%eax
80101952:	8b 40 04             	mov    0x4(%eax),%eax
80101955:	c1 e8 03             	shr    $0x3,%eax
80101958:	89 c2                	mov    %eax,%edx
8010195a:	a1 74 3a 11 80       	mov    0x80113a74,%eax
8010195f:	01 c2                	add    %eax,%edx
80101961:	8b 45 08             	mov    0x8(%ebp),%eax
80101964:	8b 00                	mov    (%eax),%eax
80101966:	83 ec 08             	sub    $0x8,%esp
80101969:	52                   	push   %edx
8010196a:	50                   	push   %eax
8010196b:	e8 67 e8 ff ff       	call   801001d7 <bread>
80101970:	83 c4 10             	add    $0x10,%esp
80101973:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101976:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101979:	8d 50 5c             	lea    0x5c(%eax),%edx
8010197c:	8b 45 08             	mov    0x8(%ebp),%eax
8010197f:	8b 40 04             	mov    0x4(%eax),%eax
80101982:	83 e0 07             	and    $0x7,%eax
80101985:	c1 e0 06             	shl    $0x6,%eax
80101988:	01 d0                	add    %edx,%eax
8010198a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
8010198d:	8b 45 08             	mov    0x8(%ebp),%eax
80101990:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101994:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101997:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010199a:	8b 45 08             	mov    0x8(%ebp),%eax
8010199d:	0f b7 50 52          	movzwl 0x52(%eax),%edx
801019a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019a4:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801019a8:	8b 45 08             	mov    0x8(%ebp),%eax
801019ab:	0f b7 50 54          	movzwl 0x54(%eax),%edx
801019af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019b2:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801019b6:	8b 45 08             	mov    0x8(%ebp),%eax
801019b9:	0f b7 50 56          	movzwl 0x56(%eax),%edx
801019bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019c0:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801019c4:	8b 45 08             	mov    0x8(%ebp),%eax
801019c7:	8b 50 58             	mov    0x58(%eax),%edx
801019ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019cd:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019d0:	8b 45 08             	mov    0x8(%ebp),%eax
801019d3:	8d 50 5c             	lea    0x5c(%eax),%edx
801019d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019d9:	83 c0 0c             	add    $0xc,%eax
801019dc:	83 ec 04             	sub    $0x4,%esp
801019df:	6a 34                	push   $0x34
801019e1:	52                   	push   %edx
801019e2:	50                   	push   %eax
801019e3:	e8 2a 3f 00 00       	call   80105912 <memmove>
801019e8:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801019eb:	83 ec 0c             	sub    $0xc,%esp
801019ee:	ff 75 f4             	pushl  -0xc(%ebp)
801019f1:	e8 50 1f 00 00       	call   80103946 <log_write>
801019f6:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801019f9:	83 ec 0c             	sub    $0xc,%esp
801019fc:	ff 75 f4             	pushl  -0xc(%ebp)
801019ff:	e8 5d e8 ff ff       	call   80100261 <brelse>
80101a04:	83 c4 10             	add    $0x10,%esp
}
80101a07:	90                   	nop
80101a08:	c9                   	leave  
80101a09:	c3                   	ret    

80101a0a <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101a0a:	f3 0f 1e fb          	endbr32 
80101a0e:	55                   	push   %ebp
80101a0f:	89 e5                	mov    %esp,%ebp
80101a11:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101a14:	83 ec 0c             	sub    $0xc,%esp
80101a17:	68 80 3a 11 80       	push   $0x80113a80
80101a1c:	e8 8b 3b 00 00       	call   801055ac <acquire>
80101a21:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101a24:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a2b:	c7 45 f4 b4 3a 11 80 	movl   $0x80113ab4,-0xc(%ebp)
80101a32:	eb 60                	jmp    80101a94 <iget+0x8a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a37:	8b 40 08             	mov    0x8(%eax),%eax
80101a3a:	85 c0                	test   %eax,%eax
80101a3c:	7e 39                	jle    80101a77 <iget+0x6d>
80101a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a41:	8b 00                	mov    (%eax),%eax
80101a43:	39 45 08             	cmp    %eax,0x8(%ebp)
80101a46:	75 2f                	jne    80101a77 <iget+0x6d>
80101a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a4b:	8b 40 04             	mov    0x4(%eax),%eax
80101a4e:	39 45 0c             	cmp    %eax,0xc(%ebp)
80101a51:	75 24                	jne    80101a77 <iget+0x6d>
      ip->ref++;
80101a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a56:	8b 40 08             	mov    0x8(%eax),%eax
80101a59:	8d 50 01             	lea    0x1(%eax),%edx
80101a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a5f:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101a62:	83 ec 0c             	sub    $0xc,%esp
80101a65:	68 80 3a 11 80       	push   $0x80113a80
80101a6a:	e8 af 3b 00 00       	call   8010561e <release>
80101a6f:	83 c4 10             	add    $0x10,%esp
      return ip;
80101a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a75:	eb 77                	jmp    80101aee <iget+0xe4>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101a77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101a7b:	75 10                	jne    80101a8d <iget+0x83>
80101a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a80:	8b 40 08             	mov    0x8(%eax),%eax
80101a83:	85 c0                	test   %eax,%eax
80101a85:	75 06                	jne    80101a8d <iget+0x83>
      empty = ip;
80101a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a8d:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80101a94:	81 7d f4 d4 56 11 80 	cmpl   $0x801156d4,-0xc(%ebp)
80101a9b:	72 97                	jb     80101a34 <iget+0x2a>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101a9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101aa1:	75 0d                	jne    80101ab0 <iget+0xa6>
    panic("iget: no inodes");
80101aa3:	83 ec 0c             	sub    $0xc,%esp
80101aa6:	68 7d 99 10 80       	push   $0x8010997d
80101aab:	e8 58 eb ff ff       	call   80100608 <panic>

  ip = empty;
80101ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ab3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ab9:	8b 55 08             	mov    0x8(%ebp),%edx
80101abc:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ac1:	8b 55 0c             	mov    0xc(%ebp),%edx
80101ac4:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101aca:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
80101ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ad4:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
80101adb:	83 ec 0c             	sub    $0xc,%esp
80101ade:	68 80 3a 11 80       	push   $0x80113a80
80101ae3:	e8 36 3b 00 00       	call   8010561e <release>
80101ae8:	83 c4 10             	add    $0x10,%esp

  return ip;
80101aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101aee:	c9                   	leave  
80101aef:	c3                   	ret    

80101af0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101af0:	f3 0f 1e fb          	endbr32 
80101af4:	55                   	push   %ebp
80101af5:	89 e5                	mov    %esp,%ebp
80101af7:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101afa:	83 ec 0c             	sub    $0xc,%esp
80101afd:	68 80 3a 11 80       	push   $0x80113a80
80101b02:	e8 a5 3a 00 00       	call   801055ac <acquire>
80101b07:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101b0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0d:	8b 40 08             	mov    0x8(%eax),%eax
80101b10:	8d 50 01             	lea    0x1(%eax),%edx
80101b13:	8b 45 08             	mov    0x8(%ebp),%eax
80101b16:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b19:	83 ec 0c             	sub    $0xc,%esp
80101b1c:	68 80 3a 11 80       	push   $0x80113a80
80101b21:	e8 f8 3a 00 00       	call   8010561e <release>
80101b26:	83 c4 10             	add    $0x10,%esp
  return ip;
80101b29:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101b2c:	c9                   	leave  
80101b2d:	c3                   	ret    

80101b2e <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101b2e:	f3 0f 1e fb          	endbr32 
80101b32:	55                   	push   %ebp
80101b33:	89 e5                	mov    %esp,%ebp
80101b35:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101b38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b3c:	74 0a                	je     80101b48 <ilock+0x1a>
80101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b41:	8b 40 08             	mov    0x8(%eax),%eax
80101b44:	85 c0                	test   %eax,%eax
80101b46:	7f 0d                	jg     80101b55 <ilock+0x27>
    panic("ilock");
80101b48:	83 ec 0c             	sub    $0xc,%esp
80101b4b:	68 8d 99 10 80       	push   $0x8010998d
80101b50:	e8 b3 ea ff ff       	call   80100608 <panic>

  acquiresleep(&ip->lock);
80101b55:	8b 45 08             	mov    0x8(%ebp),%eax
80101b58:	83 c0 0c             	add    $0xc,%eax
80101b5b:	83 ec 0c             	sub    $0xc,%esp
80101b5e:	50                   	push   %eax
80101b5f:	e8 cf 38 00 00       	call   80105433 <acquiresleep>
80101b64:	83 c4 10             	add    $0x10,%esp

  if(ip->valid == 0){
80101b67:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6a:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b6d:	85 c0                	test   %eax,%eax
80101b6f:	0f 85 cd 00 00 00    	jne    80101c42 <ilock+0x114>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b75:	8b 45 08             	mov    0x8(%ebp),%eax
80101b78:	8b 40 04             	mov    0x4(%eax),%eax
80101b7b:	c1 e8 03             	shr    $0x3,%eax
80101b7e:	89 c2                	mov    %eax,%edx
80101b80:	a1 74 3a 11 80       	mov    0x80113a74,%eax
80101b85:	01 c2                	add    %eax,%edx
80101b87:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8a:	8b 00                	mov    (%eax),%eax
80101b8c:	83 ec 08             	sub    $0x8,%esp
80101b8f:	52                   	push   %edx
80101b90:	50                   	push   %eax
80101b91:	e8 41 e6 ff ff       	call   801001d7 <bread>
80101b96:	83 c4 10             	add    $0x10,%esp
80101b99:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b9f:	8d 50 5c             	lea    0x5c(%eax),%edx
80101ba2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba5:	8b 40 04             	mov    0x4(%eax),%eax
80101ba8:	83 e0 07             	and    $0x7,%eax
80101bab:	c1 e0 06             	shl    $0x6,%eax
80101bae:	01 d0                	add    %edx,%eax
80101bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bb6:	0f b7 10             	movzwl (%eax),%edx
80101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbc:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
80101bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bc3:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101bc7:	8b 45 08             	mov    0x8(%ebp),%eax
80101bca:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
80101bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bd1:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101bd5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd8:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
80101bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bdf:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101be3:	8b 45 08             	mov    0x8(%ebp),%eax
80101be6:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
80101bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bed:	8b 50 08             	mov    0x8(%eax),%edx
80101bf0:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf3:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bf9:	8d 50 0c             	lea    0xc(%eax),%edx
80101bfc:	8b 45 08             	mov    0x8(%ebp),%eax
80101bff:	83 c0 5c             	add    $0x5c,%eax
80101c02:	83 ec 04             	sub    $0x4,%esp
80101c05:	6a 34                	push   $0x34
80101c07:	52                   	push   %edx
80101c08:	50                   	push   %eax
80101c09:	e8 04 3d 00 00       	call   80105912 <memmove>
80101c0e:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101c11:	83 ec 0c             	sub    $0xc,%esp
80101c14:	ff 75 f4             	pushl  -0xc(%ebp)
80101c17:	e8 45 e6 ff ff       	call   80100261 <brelse>
80101c1c:	83 c4 10             	add    $0x10,%esp
    ip->valid = 1;
80101c1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c22:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101c29:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2c:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101c30:	66 85 c0             	test   %ax,%ax
80101c33:	75 0d                	jne    80101c42 <ilock+0x114>
      panic("ilock: no type");
80101c35:	83 ec 0c             	sub    $0xc,%esp
80101c38:	68 93 99 10 80       	push   $0x80109993
80101c3d:	e8 c6 e9 ff ff       	call   80100608 <panic>
  }
}
80101c42:	90                   	nop
80101c43:	c9                   	leave  
80101c44:	c3                   	ret    

80101c45 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101c45:	f3 0f 1e fb          	endbr32 
80101c49:	55                   	push   %ebp
80101c4a:	89 e5                	mov    %esp,%ebp
80101c4c:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101c4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101c53:	74 20                	je     80101c75 <iunlock+0x30>
80101c55:	8b 45 08             	mov    0x8(%ebp),%eax
80101c58:	83 c0 0c             	add    $0xc,%eax
80101c5b:	83 ec 0c             	sub    $0xc,%esp
80101c5e:	50                   	push   %eax
80101c5f:	e8 89 38 00 00       	call   801054ed <holdingsleep>
80101c64:	83 c4 10             	add    $0x10,%esp
80101c67:	85 c0                	test   %eax,%eax
80101c69:	74 0a                	je     80101c75 <iunlock+0x30>
80101c6b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6e:	8b 40 08             	mov    0x8(%eax),%eax
80101c71:	85 c0                	test   %eax,%eax
80101c73:	7f 0d                	jg     80101c82 <iunlock+0x3d>
    panic("iunlock");
80101c75:	83 ec 0c             	sub    $0xc,%esp
80101c78:	68 a2 99 10 80       	push   $0x801099a2
80101c7d:	e8 86 e9 ff ff       	call   80100608 <panic>

  releasesleep(&ip->lock);
80101c82:	8b 45 08             	mov    0x8(%ebp),%eax
80101c85:	83 c0 0c             	add    $0xc,%eax
80101c88:	83 ec 0c             	sub    $0xc,%esp
80101c8b:	50                   	push   %eax
80101c8c:	e8 0a 38 00 00       	call   8010549b <releasesleep>
80101c91:	83 c4 10             	add    $0x10,%esp
}
80101c94:	90                   	nop
80101c95:	c9                   	leave  
80101c96:	c3                   	ret    

80101c97 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101c97:	f3 0f 1e fb          	endbr32 
80101c9b:	55                   	push   %ebp
80101c9c:	89 e5                	mov    %esp,%ebp
80101c9e:	83 ec 18             	sub    $0x18,%esp
  acquiresleep(&ip->lock);
80101ca1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca4:	83 c0 0c             	add    $0xc,%eax
80101ca7:	83 ec 0c             	sub    $0xc,%esp
80101caa:	50                   	push   %eax
80101cab:	e8 83 37 00 00       	call   80105433 <acquiresleep>
80101cb0:	83 c4 10             	add    $0x10,%esp
  if(ip->valid && ip->nlink == 0){
80101cb3:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb6:	8b 40 4c             	mov    0x4c(%eax),%eax
80101cb9:	85 c0                	test   %eax,%eax
80101cbb:	74 6a                	je     80101d27 <iput+0x90>
80101cbd:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc0:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101cc4:	66 85 c0             	test   %ax,%ax
80101cc7:	75 5e                	jne    80101d27 <iput+0x90>
    acquire(&icache.lock);
80101cc9:	83 ec 0c             	sub    $0xc,%esp
80101ccc:	68 80 3a 11 80       	push   $0x80113a80
80101cd1:	e8 d6 38 00 00       	call   801055ac <acquire>
80101cd6:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101cd9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cdc:	8b 40 08             	mov    0x8(%eax),%eax
80101cdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101ce2:	83 ec 0c             	sub    $0xc,%esp
80101ce5:	68 80 3a 11 80       	push   $0x80113a80
80101cea:	e8 2f 39 00 00       	call   8010561e <release>
80101cef:	83 c4 10             	add    $0x10,%esp
    if(r == 1){
80101cf2:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101cf6:	75 2f                	jne    80101d27 <iput+0x90>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101cf8:	83 ec 0c             	sub    $0xc,%esp
80101cfb:	ff 75 08             	pushl  0x8(%ebp)
80101cfe:	e8 b5 01 00 00       	call   80101eb8 <itrunc>
80101d03:	83 c4 10             	add    $0x10,%esp
      ip->type = 0;
80101d06:	8b 45 08             	mov    0x8(%ebp),%eax
80101d09:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101d0f:	83 ec 0c             	sub    $0xc,%esp
80101d12:	ff 75 08             	pushl  0x8(%ebp)
80101d15:	e8 2b fc ff ff       	call   80101945 <iupdate>
80101d1a:	83 c4 10             	add    $0x10,%esp
      ip->valid = 0;
80101d1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d20:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101d27:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2a:	83 c0 0c             	add    $0xc,%eax
80101d2d:	83 ec 0c             	sub    $0xc,%esp
80101d30:	50                   	push   %eax
80101d31:	e8 65 37 00 00       	call   8010549b <releasesleep>
80101d36:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101d39:	83 ec 0c             	sub    $0xc,%esp
80101d3c:	68 80 3a 11 80       	push   $0x80113a80
80101d41:	e8 66 38 00 00       	call   801055ac <acquire>
80101d46:	83 c4 10             	add    $0x10,%esp
  ip->ref--;
80101d49:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4c:	8b 40 08             	mov    0x8(%eax),%eax
80101d4f:	8d 50 ff             	lea    -0x1(%eax),%edx
80101d52:	8b 45 08             	mov    0x8(%ebp),%eax
80101d55:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101d58:	83 ec 0c             	sub    $0xc,%esp
80101d5b:	68 80 3a 11 80       	push   $0x80113a80
80101d60:	e8 b9 38 00 00       	call   8010561e <release>
80101d65:	83 c4 10             	add    $0x10,%esp
}
80101d68:	90                   	nop
80101d69:	c9                   	leave  
80101d6a:	c3                   	ret    

80101d6b <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101d6b:	f3 0f 1e fb          	endbr32 
80101d6f:	55                   	push   %ebp
80101d70:	89 e5                	mov    %esp,%ebp
80101d72:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101d75:	83 ec 0c             	sub    $0xc,%esp
80101d78:	ff 75 08             	pushl  0x8(%ebp)
80101d7b:	e8 c5 fe ff ff       	call   80101c45 <iunlock>
80101d80:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101d83:	83 ec 0c             	sub    $0xc,%esp
80101d86:	ff 75 08             	pushl  0x8(%ebp)
80101d89:	e8 09 ff ff ff       	call   80101c97 <iput>
80101d8e:	83 c4 10             	add    $0x10,%esp
}
80101d91:	90                   	nop
80101d92:	c9                   	leave  
80101d93:	c3                   	ret    

80101d94 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101d94:	f3 0f 1e fb          	endbr32 
80101d98:	55                   	push   %ebp
80101d99:	89 e5                	mov    %esp,%ebp
80101d9b:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101d9e:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101da2:	77 42                	ja     80101de6 <bmap+0x52>
    if((addr = ip->addrs[bn]) == 0)
80101da4:	8b 45 08             	mov    0x8(%ebp),%eax
80101da7:	8b 55 0c             	mov    0xc(%ebp),%edx
80101daa:	83 c2 14             	add    $0x14,%edx
80101dad:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101db1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101db4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101db8:	75 24                	jne    80101dde <bmap+0x4a>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101dba:	8b 45 08             	mov    0x8(%ebp),%eax
80101dbd:	8b 00                	mov    (%eax),%eax
80101dbf:	83 ec 0c             	sub    $0xc,%esp
80101dc2:	50                   	push   %eax
80101dc3:	e8 c7 f7 ff ff       	call   8010158f <balloc>
80101dc8:	83 c4 10             	add    $0x10,%esp
80101dcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101dce:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd1:	8b 55 0c             	mov    0xc(%ebp),%edx
80101dd4:	8d 4a 14             	lea    0x14(%edx),%ecx
80101dd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dda:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101de1:	e9 d0 00 00 00       	jmp    80101eb6 <bmap+0x122>
  }
  bn -= NDIRECT;
80101de6:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101dea:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101dee:	0f 87 b5 00 00 00    	ja     80101ea9 <bmap+0x115>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101df4:	8b 45 08             	mov    0x8(%ebp),%eax
80101df7:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101dfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101e04:	75 20                	jne    80101e26 <bmap+0x92>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101e06:	8b 45 08             	mov    0x8(%ebp),%eax
80101e09:	8b 00                	mov    (%eax),%eax
80101e0b:	83 ec 0c             	sub    $0xc,%esp
80101e0e:	50                   	push   %eax
80101e0f:	e8 7b f7 ff ff       	call   8010158f <balloc>
80101e14:	83 c4 10             	add    $0x10,%esp
80101e17:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e1a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e20:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101e26:	8b 45 08             	mov    0x8(%ebp),%eax
80101e29:	8b 00                	mov    (%eax),%eax
80101e2b:	83 ec 08             	sub    $0x8,%esp
80101e2e:	ff 75 f4             	pushl  -0xc(%ebp)
80101e31:	50                   	push   %eax
80101e32:	e8 a0 e3 ff ff       	call   801001d7 <bread>
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101e3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e40:	83 c0 5c             	add    $0x5c,%eax
80101e43:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101e46:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e49:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e50:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e53:	01 d0                	add    %edx,%eax
80101e55:	8b 00                	mov    (%eax),%eax
80101e57:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101e5e:	75 36                	jne    80101e96 <bmap+0x102>
      a[bn] = addr = balloc(ip->dev);
80101e60:	8b 45 08             	mov    0x8(%ebp),%eax
80101e63:	8b 00                	mov    (%eax),%eax
80101e65:	83 ec 0c             	sub    $0xc,%esp
80101e68:	50                   	push   %eax
80101e69:	e8 21 f7 ff ff       	call   8010158f <balloc>
80101e6e:	83 c4 10             	add    $0x10,%esp
80101e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e74:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e77:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e81:	01 c2                	add    %eax,%edx
80101e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e86:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101e88:	83 ec 0c             	sub    $0xc,%esp
80101e8b:	ff 75 f0             	pushl  -0x10(%ebp)
80101e8e:	e8 b3 1a 00 00       	call   80103946 <log_write>
80101e93:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101e96:	83 ec 0c             	sub    $0xc,%esp
80101e99:	ff 75 f0             	pushl  -0x10(%ebp)
80101e9c:	e8 c0 e3 ff ff       	call   80100261 <brelse>
80101ea1:	83 c4 10             	add    $0x10,%esp
    return addr;
80101ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ea7:	eb 0d                	jmp    80101eb6 <bmap+0x122>
  }

  panic("bmap: out of range");
80101ea9:	83 ec 0c             	sub    $0xc,%esp
80101eac:	68 aa 99 10 80       	push   $0x801099aa
80101eb1:	e8 52 e7 ff ff       	call   80100608 <panic>
}
80101eb6:	c9                   	leave  
80101eb7:	c3                   	ret    

80101eb8 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101eb8:	f3 0f 1e fb          	endbr32 
80101ebc:	55                   	push   %ebp
80101ebd:	89 e5                	mov    %esp,%ebp
80101ebf:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101ec2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101ec9:	eb 45                	jmp    80101f10 <itrunc+0x58>
    if(ip->addrs[i]){
80101ecb:	8b 45 08             	mov    0x8(%ebp),%eax
80101ece:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ed1:	83 c2 14             	add    $0x14,%edx
80101ed4:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101ed8:	85 c0                	test   %eax,%eax
80101eda:	74 30                	je     80101f0c <itrunc+0x54>
      bfree(ip->dev, ip->addrs[i]);
80101edc:	8b 45 08             	mov    0x8(%ebp),%eax
80101edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ee2:	83 c2 14             	add    $0x14,%edx
80101ee5:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101ee9:	8b 55 08             	mov    0x8(%ebp),%edx
80101eec:	8b 12                	mov    (%edx),%edx
80101eee:	83 ec 08             	sub    $0x8,%esp
80101ef1:	50                   	push   %eax
80101ef2:	52                   	push   %edx
80101ef3:	e8 e7 f7 ff ff       	call   801016df <bfree>
80101ef8:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101efb:	8b 45 08             	mov    0x8(%ebp),%eax
80101efe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101f01:	83 c2 14             	add    $0x14,%edx
80101f04:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101f0b:	00 
  for(i = 0; i < NDIRECT; i++){
80101f0c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101f10:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101f14:	7e b5                	jle    80101ecb <itrunc+0x13>
    }
  }

  if(ip->addrs[NDIRECT]){
80101f16:	8b 45 08             	mov    0x8(%ebp),%eax
80101f19:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101f1f:	85 c0                	test   %eax,%eax
80101f21:	0f 84 aa 00 00 00    	je     80101fd1 <itrunc+0x119>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101f27:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2a:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101f30:	8b 45 08             	mov    0x8(%ebp),%eax
80101f33:	8b 00                	mov    (%eax),%eax
80101f35:	83 ec 08             	sub    $0x8,%esp
80101f38:	52                   	push   %edx
80101f39:	50                   	push   %eax
80101f3a:	e8 98 e2 ff ff       	call   801001d7 <bread>
80101f3f:	83 c4 10             	add    $0x10,%esp
80101f42:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101f45:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f48:	83 c0 5c             	add    $0x5c,%eax
80101f4b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101f4e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101f55:	eb 3c                	jmp    80101f93 <itrunc+0xdb>
      if(a[j])
80101f57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f5a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f61:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101f64:	01 d0                	add    %edx,%eax
80101f66:	8b 00                	mov    (%eax),%eax
80101f68:	85 c0                	test   %eax,%eax
80101f6a:	74 23                	je     80101f8f <itrunc+0xd7>
        bfree(ip->dev, a[j]);
80101f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f6f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f76:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101f79:	01 d0                	add    %edx,%eax
80101f7b:	8b 00                	mov    (%eax),%eax
80101f7d:	8b 55 08             	mov    0x8(%ebp),%edx
80101f80:	8b 12                	mov    (%edx),%edx
80101f82:	83 ec 08             	sub    $0x8,%esp
80101f85:	50                   	push   %eax
80101f86:	52                   	push   %edx
80101f87:	e8 53 f7 ff ff       	call   801016df <bfree>
80101f8c:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
80101f8f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f96:	83 f8 7f             	cmp    $0x7f,%eax
80101f99:	76 bc                	jbe    80101f57 <itrunc+0x9f>
    }
    brelse(bp);
80101f9b:	83 ec 0c             	sub    $0xc,%esp
80101f9e:	ff 75 ec             	pushl  -0x14(%ebp)
80101fa1:	e8 bb e2 ff ff       	call   80100261 <brelse>
80101fa6:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101fa9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fac:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101fb2:	8b 55 08             	mov    0x8(%ebp),%edx
80101fb5:	8b 12                	mov    (%edx),%edx
80101fb7:	83 ec 08             	sub    $0x8,%esp
80101fba:	50                   	push   %eax
80101fbb:	52                   	push   %edx
80101fbc:	e8 1e f7 ff ff       	call   801016df <bfree>
80101fc1:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101fc4:	8b 45 08             	mov    0x8(%ebp),%eax
80101fc7:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101fce:	00 00 00 
  }

  ip->size = 0;
80101fd1:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd4:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101fdb:	83 ec 0c             	sub    $0xc,%esp
80101fde:	ff 75 08             	pushl  0x8(%ebp)
80101fe1:	e8 5f f9 ff ff       	call   80101945 <iupdate>
80101fe6:	83 c4 10             	add    $0x10,%esp
}
80101fe9:	90                   	nop
80101fea:	c9                   	leave  
80101feb:	c3                   	ret    

80101fec <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101fec:	f3 0f 1e fb          	endbr32 
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101ff3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff6:	8b 00                	mov    (%eax),%eax
80101ff8:	89 c2                	mov    %eax,%edx
80101ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ffd:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80102000:	8b 45 08             	mov    0x8(%ebp),%eax
80102003:	8b 50 04             	mov    0x4(%eax),%edx
80102006:	8b 45 0c             	mov    0xc(%ebp),%eax
80102009:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
8010200c:	8b 45 08             	mov    0x8(%ebp),%eax
8010200f:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80102013:	8b 45 0c             	mov    0xc(%ebp),%eax
80102016:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80102019:	8b 45 08             	mov    0x8(%ebp),%eax
8010201c:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80102020:	8b 45 0c             	mov    0xc(%ebp),%eax
80102023:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80102027:	8b 45 08             	mov    0x8(%ebp),%eax
8010202a:	8b 50 58             	mov    0x58(%eax),%edx
8010202d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102030:	89 50 10             	mov    %edx,0x10(%eax)
}
80102033:	90                   	nop
80102034:	5d                   	pop    %ebp
80102035:	c3                   	ret    

80102036 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102036:	f3 0f 1e fb          	endbr32 
8010203a:	55                   	push   %ebp
8010203b:	89 e5                	mov    %esp,%ebp
8010203d:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102040:	8b 45 08             	mov    0x8(%ebp),%eax
80102043:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102047:	66 83 f8 03          	cmp    $0x3,%ax
8010204b:	75 5c                	jne    801020a9 <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
8010204d:	8b 45 08             	mov    0x8(%ebp),%eax
80102050:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102054:	66 85 c0             	test   %ax,%ax
80102057:	78 20                	js     80102079 <readi+0x43>
80102059:	8b 45 08             	mov    0x8(%ebp),%eax
8010205c:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102060:	66 83 f8 09          	cmp    $0x9,%ax
80102064:	7f 13                	jg     80102079 <readi+0x43>
80102066:	8b 45 08             	mov    0x8(%ebp),%eax
80102069:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010206d:	98                   	cwtl   
8010206e:	8b 04 c5 00 3a 11 80 	mov    -0x7feec600(,%eax,8),%eax
80102075:	85 c0                	test   %eax,%eax
80102077:	75 0a                	jne    80102083 <readi+0x4d>
      return -1;
80102079:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010207e:	e9 0a 01 00 00       	jmp    8010218d <readi+0x157>
    return devsw[ip->major].read(ip, dst, n);
80102083:	8b 45 08             	mov    0x8(%ebp),%eax
80102086:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010208a:	98                   	cwtl   
8010208b:	8b 04 c5 00 3a 11 80 	mov    -0x7feec600(,%eax,8),%eax
80102092:	8b 55 14             	mov    0x14(%ebp),%edx
80102095:	83 ec 04             	sub    $0x4,%esp
80102098:	52                   	push   %edx
80102099:	ff 75 0c             	pushl  0xc(%ebp)
8010209c:	ff 75 08             	pushl  0x8(%ebp)
8010209f:	ff d0                	call   *%eax
801020a1:	83 c4 10             	add    $0x10,%esp
801020a4:	e9 e4 00 00 00       	jmp    8010218d <readi+0x157>
  }

  if(off > ip->size || off + n < off)
801020a9:	8b 45 08             	mov    0x8(%ebp),%eax
801020ac:	8b 40 58             	mov    0x58(%eax),%eax
801020af:	39 45 10             	cmp    %eax,0x10(%ebp)
801020b2:	77 0d                	ja     801020c1 <readi+0x8b>
801020b4:	8b 55 10             	mov    0x10(%ebp),%edx
801020b7:	8b 45 14             	mov    0x14(%ebp),%eax
801020ba:	01 d0                	add    %edx,%eax
801020bc:	39 45 10             	cmp    %eax,0x10(%ebp)
801020bf:	76 0a                	jbe    801020cb <readi+0x95>
    return -1;
801020c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020c6:	e9 c2 00 00 00       	jmp    8010218d <readi+0x157>
  if(off + n > ip->size)
801020cb:	8b 55 10             	mov    0x10(%ebp),%edx
801020ce:	8b 45 14             	mov    0x14(%ebp),%eax
801020d1:	01 c2                	add    %eax,%edx
801020d3:	8b 45 08             	mov    0x8(%ebp),%eax
801020d6:	8b 40 58             	mov    0x58(%eax),%eax
801020d9:	39 c2                	cmp    %eax,%edx
801020db:	76 0c                	jbe    801020e9 <readi+0xb3>
    n = ip->size - off;
801020dd:	8b 45 08             	mov    0x8(%ebp),%eax
801020e0:	8b 40 58             	mov    0x58(%eax),%eax
801020e3:	2b 45 10             	sub    0x10(%ebp),%eax
801020e6:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801020e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020f0:	e9 89 00 00 00       	jmp    8010217e <readi+0x148>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020f5:	8b 45 10             	mov    0x10(%ebp),%eax
801020f8:	c1 e8 09             	shr    $0x9,%eax
801020fb:	83 ec 08             	sub    $0x8,%esp
801020fe:	50                   	push   %eax
801020ff:	ff 75 08             	pushl  0x8(%ebp)
80102102:	e8 8d fc ff ff       	call   80101d94 <bmap>
80102107:	83 c4 10             	add    $0x10,%esp
8010210a:	8b 55 08             	mov    0x8(%ebp),%edx
8010210d:	8b 12                	mov    (%edx),%edx
8010210f:	83 ec 08             	sub    $0x8,%esp
80102112:	50                   	push   %eax
80102113:	52                   	push   %edx
80102114:	e8 be e0 ff ff       	call   801001d7 <bread>
80102119:	83 c4 10             	add    $0x10,%esp
8010211c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010211f:	8b 45 10             	mov    0x10(%ebp),%eax
80102122:	25 ff 01 00 00       	and    $0x1ff,%eax
80102127:	ba 00 02 00 00       	mov    $0x200,%edx
8010212c:	29 c2                	sub    %eax,%edx
8010212e:	8b 45 14             	mov    0x14(%ebp),%eax
80102131:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102134:	39 c2                	cmp    %eax,%edx
80102136:	0f 46 c2             	cmovbe %edx,%eax
80102139:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
8010213c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010213f:	8d 50 5c             	lea    0x5c(%eax),%edx
80102142:	8b 45 10             	mov    0x10(%ebp),%eax
80102145:	25 ff 01 00 00       	and    $0x1ff,%eax
8010214a:	01 d0                	add    %edx,%eax
8010214c:	83 ec 04             	sub    $0x4,%esp
8010214f:	ff 75 ec             	pushl  -0x14(%ebp)
80102152:	50                   	push   %eax
80102153:	ff 75 0c             	pushl  0xc(%ebp)
80102156:	e8 b7 37 00 00       	call   80105912 <memmove>
8010215b:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010215e:	83 ec 0c             	sub    $0xc,%esp
80102161:	ff 75 f0             	pushl  -0x10(%ebp)
80102164:	e8 f8 e0 ff ff       	call   80100261 <brelse>
80102169:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010216c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010216f:	01 45 f4             	add    %eax,-0xc(%ebp)
80102172:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102175:	01 45 10             	add    %eax,0x10(%ebp)
80102178:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010217b:	01 45 0c             	add    %eax,0xc(%ebp)
8010217e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102181:	3b 45 14             	cmp    0x14(%ebp),%eax
80102184:	0f 82 6b ff ff ff    	jb     801020f5 <readi+0xbf>
  }
  return n;
8010218a:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010218d:	c9                   	leave  
8010218e:	c3                   	ret    

8010218f <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
8010218f:	f3 0f 1e fb          	endbr32 
80102193:	55                   	push   %ebp
80102194:	89 e5                	mov    %esp,%ebp
80102196:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102199:	8b 45 08             	mov    0x8(%ebp),%eax
8010219c:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801021a0:	66 83 f8 03          	cmp    $0x3,%ax
801021a4:	75 5c                	jne    80102202 <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801021a6:	8b 45 08             	mov    0x8(%ebp),%eax
801021a9:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801021ad:	66 85 c0             	test   %ax,%ax
801021b0:	78 20                	js     801021d2 <writei+0x43>
801021b2:	8b 45 08             	mov    0x8(%ebp),%eax
801021b5:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801021b9:	66 83 f8 09          	cmp    $0x9,%ax
801021bd:	7f 13                	jg     801021d2 <writei+0x43>
801021bf:	8b 45 08             	mov    0x8(%ebp),%eax
801021c2:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801021c6:	98                   	cwtl   
801021c7:	8b 04 c5 04 3a 11 80 	mov    -0x7feec5fc(,%eax,8),%eax
801021ce:	85 c0                	test   %eax,%eax
801021d0:	75 0a                	jne    801021dc <writei+0x4d>
      return -1;
801021d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021d7:	e9 3b 01 00 00       	jmp    80102317 <writei+0x188>
    return devsw[ip->major].write(ip, src, n);
801021dc:	8b 45 08             	mov    0x8(%ebp),%eax
801021df:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801021e3:	98                   	cwtl   
801021e4:	8b 04 c5 04 3a 11 80 	mov    -0x7feec5fc(,%eax,8),%eax
801021eb:	8b 55 14             	mov    0x14(%ebp),%edx
801021ee:	83 ec 04             	sub    $0x4,%esp
801021f1:	52                   	push   %edx
801021f2:	ff 75 0c             	pushl  0xc(%ebp)
801021f5:	ff 75 08             	pushl  0x8(%ebp)
801021f8:	ff d0                	call   *%eax
801021fa:	83 c4 10             	add    $0x10,%esp
801021fd:	e9 15 01 00 00       	jmp    80102317 <writei+0x188>
  }

  if(off > ip->size || off + n < off)
80102202:	8b 45 08             	mov    0x8(%ebp),%eax
80102205:	8b 40 58             	mov    0x58(%eax),%eax
80102208:	39 45 10             	cmp    %eax,0x10(%ebp)
8010220b:	77 0d                	ja     8010221a <writei+0x8b>
8010220d:	8b 55 10             	mov    0x10(%ebp),%edx
80102210:	8b 45 14             	mov    0x14(%ebp),%eax
80102213:	01 d0                	add    %edx,%eax
80102215:	39 45 10             	cmp    %eax,0x10(%ebp)
80102218:	76 0a                	jbe    80102224 <writei+0x95>
    return -1;
8010221a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010221f:	e9 f3 00 00 00       	jmp    80102317 <writei+0x188>
  if(off + n > MAXFILE*BSIZE)
80102224:	8b 55 10             	mov    0x10(%ebp),%edx
80102227:	8b 45 14             	mov    0x14(%ebp),%eax
8010222a:	01 d0                	add    %edx,%eax
8010222c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102231:	76 0a                	jbe    8010223d <writei+0xae>
    return -1;
80102233:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102238:	e9 da 00 00 00       	jmp    80102317 <writei+0x188>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010223d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102244:	e9 97 00 00 00       	jmp    801022e0 <writei+0x151>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102249:	8b 45 10             	mov    0x10(%ebp),%eax
8010224c:	c1 e8 09             	shr    $0x9,%eax
8010224f:	83 ec 08             	sub    $0x8,%esp
80102252:	50                   	push   %eax
80102253:	ff 75 08             	pushl  0x8(%ebp)
80102256:	e8 39 fb ff ff       	call   80101d94 <bmap>
8010225b:	83 c4 10             	add    $0x10,%esp
8010225e:	8b 55 08             	mov    0x8(%ebp),%edx
80102261:	8b 12                	mov    (%edx),%edx
80102263:	83 ec 08             	sub    $0x8,%esp
80102266:	50                   	push   %eax
80102267:	52                   	push   %edx
80102268:	e8 6a df ff ff       	call   801001d7 <bread>
8010226d:	83 c4 10             	add    $0x10,%esp
80102270:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102273:	8b 45 10             	mov    0x10(%ebp),%eax
80102276:	25 ff 01 00 00       	and    $0x1ff,%eax
8010227b:	ba 00 02 00 00       	mov    $0x200,%edx
80102280:	29 c2                	sub    %eax,%edx
80102282:	8b 45 14             	mov    0x14(%ebp),%eax
80102285:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102288:	39 c2                	cmp    %eax,%edx
8010228a:	0f 46 c2             	cmovbe %edx,%eax
8010228d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102290:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102293:	8d 50 5c             	lea    0x5c(%eax),%edx
80102296:	8b 45 10             	mov    0x10(%ebp),%eax
80102299:	25 ff 01 00 00       	and    $0x1ff,%eax
8010229e:	01 d0                	add    %edx,%eax
801022a0:	83 ec 04             	sub    $0x4,%esp
801022a3:	ff 75 ec             	pushl  -0x14(%ebp)
801022a6:	ff 75 0c             	pushl  0xc(%ebp)
801022a9:	50                   	push   %eax
801022aa:	e8 63 36 00 00       	call   80105912 <memmove>
801022af:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
801022b2:	83 ec 0c             	sub    $0xc,%esp
801022b5:	ff 75 f0             	pushl  -0x10(%ebp)
801022b8:	e8 89 16 00 00       	call   80103946 <log_write>
801022bd:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801022c0:	83 ec 0c             	sub    $0xc,%esp
801022c3:	ff 75 f0             	pushl  -0x10(%ebp)
801022c6:	e8 96 df ff ff       	call   80100261 <brelse>
801022cb:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801022ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022d1:	01 45 f4             	add    %eax,-0xc(%ebp)
801022d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022d7:	01 45 10             	add    %eax,0x10(%ebp)
801022da:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022dd:	01 45 0c             	add    %eax,0xc(%ebp)
801022e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022e3:	3b 45 14             	cmp    0x14(%ebp),%eax
801022e6:	0f 82 5d ff ff ff    	jb     80102249 <writei+0xba>
  }

  if(n > 0 && off > ip->size){
801022ec:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801022f0:	74 22                	je     80102314 <writei+0x185>
801022f2:	8b 45 08             	mov    0x8(%ebp),%eax
801022f5:	8b 40 58             	mov    0x58(%eax),%eax
801022f8:	39 45 10             	cmp    %eax,0x10(%ebp)
801022fb:	76 17                	jbe    80102314 <writei+0x185>
    ip->size = off;
801022fd:	8b 45 08             	mov    0x8(%ebp),%eax
80102300:	8b 55 10             	mov    0x10(%ebp),%edx
80102303:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
80102306:	83 ec 0c             	sub    $0xc,%esp
80102309:	ff 75 08             	pushl  0x8(%ebp)
8010230c:	e8 34 f6 ff ff       	call   80101945 <iupdate>
80102311:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102314:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102317:	c9                   	leave  
80102318:	c3                   	ret    

80102319 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102319:	f3 0f 1e fb          	endbr32 
8010231d:	55                   	push   %ebp
8010231e:	89 e5                	mov    %esp,%ebp
80102320:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102323:	83 ec 04             	sub    $0x4,%esp
80102326:	6a 0e                	push   $0xe
80102328:	ff 75 0c             	pushl  0xc(%ebp)
8010232b:	ff 75 08             	pushl  0x8(%ebp)
8010232e:	e8 7d 36 00 00       	call   801059b0 <strncmp>
80102333:	83 c4 10             	add    $0x10,%esp
}
80102336:	c9                   	leave  
80102337:	c3                   	ret    

80102338 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102338:	f3 0f 1e fb          	endbr32 
8010233c:	55                   	push   %ebp
8010233d:	89 e5                	mov    %esp,%ebp
8010233f:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102342:	8b 45 08             	mov    0x8(%ebp),%eax
80102345:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102349:	66 83 f8 01          	cmp    $0x1,%ax
8010234d:	74 0d                	je     8010235c <dirlookup+0x24>
    panic("dirlookup not DIR");
8010234f:	83 ec 0c             	sub    $0xc,%esp
80102352:	68 bd 99 10 80       	push   $0x801099bd
80102357:	e8 ac e2 ff ff       	call   80100608 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010235c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102363:	eb 7b                	jmp    801023e0 <dirlookup+0xa8>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102365:	6a 10                	push   $0x10
80102367:	ff 75 f4             	pushl  -0xc(%ebp)
8010236a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010236d:	50                   	push   %eax
8010236e:	ff 75 08             	pushl  0x8(%ebp)
80102371:	e8 c0 fc ff ff       	call   80102036 <readi>
80102376:	83 c4 10             	add    $0x10,%esp
80102379:	83 f8 10             	cmp    $0x10,%eax
8010237c:	74 0d                	je     8010238b <dirlookup+0x53>
      panic("dirlookup read");
8010237e:	83 ec 0c             	sub    $0xc,%esp
80102381:	68 cf 99 10 80       	push   $0x801099cf
80102386:	e8 7d e2 ff ff       	call   80100608 <panic>
    if(de.inum == 0)
8010238b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010238f:	66 85 c0             	test   %ax,%ax
80102392:	74 47                	je     801023db <dirlookup+0xa3>
      continue;
    if(namecmp(name, de.name) == 0){
80102394:	83 ec 08             	sub    $0x8,%esp
80102397:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010239a:	83 c0 02             	add    $0x2,%eax
8010239d:	50                   	push   %eax
8010239e:	ff 75 0c             	pushl  0xc(%ebp)
801023a1:	e8 73 ff ff ff       	call   80102319 <namecmp>
801023a6:	83 c4 10             	add    $0x10,%esp
801023a9:	85 c0                	test   %eax,%eax
801023ab:	75 2f                	jne    801023dc <dirlookup+0xa4>
      // entry matches path element
      if(poff)
801023ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801023b1:	74 08                	je     801023bb <dirlookup+0x83>
        *poff = off;
801023b3:	8b 45 10             	mov    0x10(%ebp),%eax
801023b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801023b9:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801023bb:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801023bf:	0f b7 c0             	movzwl %ax,%eax
801023c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801023c5:	8b 45 08             	mov    0x8(%ebp),%eax
801023c8:	8b 00                	mov    (%eax),%eax
801023ca:	83 ec 08             	sub    $0x8,%esp
801023cd:	ff 75 f0             	pushl  -0x10(%ebp)
801023d0:	50                   	push   %eax
801023d1:	e8 34 f6 ff ff       	call   80101a0a <iget>
801023d6:	83 c4 10             	add    $0x10,%esp
801023d9:	eb 19                	jmp    801023f4 <dirlookup+0xbc>
      continue;
801023db:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
801023dc:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801023e0:	8b 45 08             	mov    0x8(%ebp),%eax
801023e3:	8b 40 58             	mov    0x58(%eax),%eax
801023e6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801023e9:	0f 82 76 ff ff ff    	jb     80102365 <dirlookup+0x2d>
    }
  }

  return 0;
801023ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
801023f4:	c9                   	leave  
801023f5:	c3                   	ret    

801023f6 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801023f6:	f3 0f 1e fb          	endbr32 
801023fa:	55                   	push   %ebp
801023fb:	89 e5                	mov    %esp,%ebp
801023fd:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102400:	83 ec 04             	sub    $0x4,%esp
80102403:	6a 00                	push   $0x0
80102405:	ff 75 0c             	pushl  0xc(%ebp)
80102408:	ff 75 08             	pushl  0x8(%ebp)
8010240b:	e8 28 ff ff ff       	call   80102338 <dirlookup>
80102410:	83 c4 10             	add    $0x10,%esp
80102413:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102416:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010241a:	74 18                	je     80102434 <dirlink+0x3e>
    iput(ip);
8010241c:	83 ec 0c             	sub    $0xc,%esp
8010241f:	ff 75 f0             	pushl  -0x10(%ebp)
80102422:	e8 70 f8 ff ff       	call   80101c97 <iput>
80102427:	83 c4 10             	add    $0x10,%esp
    return -1;
8010242a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010242f:	e9 9c 00 00 00       	jmp    801024d0 <dirlink+0xda>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102434:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010243b:	eb 39                	jmp    80102476 <dirlink+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010243d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102440:	6a 10                	push   $0x10
80102442:	50                   	push   %eax
80102443:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102446:	50                   	push   %eax
80102447:	ff 75 08             	pushl  0x8(%ebp)
8010244a:	e8 e7 fb ff ff       	call   80102036 <readi>
8010244f:	83 c4 10             	add    $0x10,%esp
80102452:	83 f8 10             	cmp    $0x10,%eax
80102455:	74 0d                	je     80102464 <dirlink+0x6e>
      panic("dirlink read");
80102457:	83 ec 0c             	sub    $0xc,%esp
8010245a:	68 de 99 10 80       	push   $0x801099de
8010245f:	e8 a4 e1 ff ff       	call   80100608 <panic>
    if(de.inum == 0)
80102464:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102468:	66 85 c0             	test   %ax,%ax
8010246b:	74 18                	je     80102485 <dirlink+0x8f>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102470:	83 c0 10             	add    $0x10,%eax
80102473:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102476:	8b 45 08             	mov    0x8(%ebp),%eax
80102479:	8b 50 58             	mov    0x58(%eax),%edx
8010247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010247f:	39 c2                	cmp    %eax,%edx
80102481:	77 ba                	ja     8010243d <dirlink+0x47>
80102483:	eb 01                	jmp    80102486 <dirlink+0x90>
      break;
80102485:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102486:	83 ec 04             	sub    $0x4,%esp
80102489:	6a 0e                	push   $0xe
8010248b:	ff 75 0c             	pushl  0xc(%ebp)
8010248e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102491:	83 c0 02             	add    $0x2,%eax
80102494:	50                   	push   %eax
80102495:	e8 70 35 00 00       	call   80105a0a <strncpy>
8010249a:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
8010249d:	8b 45 10             	mov    0x10(%ebp),%eax
801024a0:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024a7:	6a 10                	push   $0x10
801024a9:	50                   	push   %eax
801024aa:	8d 45 e0             	lea    -0x20(%ebp),%eax
801024ad:	50                   	push   %eax
801024ae:	ff 75 08             	pushl  0x8(%ebp)
801024b1:	e8 d9 fc ff ff       	call   8010218f <writei>
801024b6:	83 c4 10             	add    $0x10,%esp
801024b9:	83 f8 10             	cmp    $0x10,%eax
801024bc:	74 0d                	je     801024cb <dirlink+0xd5>
    panic("dirlink");
801024be:	83 ec 0c             	sub    $0xc,%esp
801024c1:	68 eb 99 10 80       	push   $0x801099eb
801024c6:	e8 3d e1 ff ff       	call   80100608 <panic>

  return 0;
801024cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801024d0:	c9                   	leave  
801024d1:	c3                   	ret    

801024d2 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801024d2:	f3 0f 1e fb          	endbr32 
801024d6:	55                   	push   %ebp
801024d7:	89 e5                	mov    %esp,%ebp
801024d9:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
801024dc:	eb 04                	jmp    801024e2 <skipelem+0x10>
    path++;
801024de:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
801024e2:	8b 45 08             	mov    0x8(%ebp),%eax
801024e5:	0f b6 00             	movzbl (%eax),%eax
801024e8:	3c 2f                	cmp    $0x2f,%al
801024ea:	74 f2                	je     801024de <skipelem+0xc>
  if(*path == 0)
801024ec:	8b 45 08             	mov    0x8(%ebp),%eax
801024ef:	0f b6 00             	movzbl (%eax),%eax
801024f2:	84 c0                	test   %al,%al
801024f4:	75 07                	jne    801024fd <skipelem+0x2b>
    return 0;
801024f6:	b8 00 00 00 00       	mov    $0x0,%eax
801024fb:	eb 77                	jmp    80102574 <skipelem+0xa2>
  s = path;
801024fd:	8b 45 08             	mov    0x8(%ebp),%eax
80102500:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102503:	eb 04                	jmp    80102509 <skipelem+0x37>
    path++;
80102505:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
80102509:	8b 45 08             	mov    0x8(%ebp),%eax
8010250c:	0f b6 00             	movzbl (%eax),%eax
8010250f:	3c 2f                	cmp    $0x2f,%al
80102511:	74 0a                	je     8010251d <skipelem+0x4b>
80102513:	8b 45 08             	mov    0x8(%ebp),%eax
80102516:	0f b6 00             	movzbl (%eax),%eax
80102519:	84 c0                	test   %al,%al
8010251b:	75 e8                	jne    80102505 <skipelem+0x33>
  len = path - s;
8010251d:	8b 45 08             	mov    0x8(%ebp),%eax
80102520:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102523:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102526:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010252a:	7e 15                	jle    80102541 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
8010252c:	83 ec 04             	sub    $0x4,%esp
8010252f:	6a 0e                	push   $0xe
80102531:	ff 75 f4             	pushl  -0xc(%ebp)
80102534:	ff 75 0c             	pushl  0xc(%ebp)
80102537:	e8 d6 33 00 00       	call   80105912 <memmove>
8010253c:	83 c4 10             	add    $0x10,%esp
8010253f:	eb 26                	jmp    80102567 <skipelem+0x95>
  else {
    memmove(name, s, len);
80102541:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102544:	83 ec 04             	sub    $0x4,%esp
80102547:	50                   	push   %eax
80102548:	ff 75 f4             	pushl  -0xc(%ebp)
8010254b:	ff 75 0c             	pushl  0xc(%ebp)
8010254e:	e8 bf 33 00 00       	call   80105912 <memmove>
80102553:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102556:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102559:	8b 45 0c             	mov    0xc(%ebp),%eax
8010255c:	01 d0                	add    %edx,%eax
8010255e:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102561:	eb 04                	jmp    80102567 <skipelem+0x95>
    path++;
80102563:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102567:	8b 45 08             	mov    0x8(%ebp),%eax
8010256a:	0f b6 00             	movzbl (%eax),%eax
8010256d:	3c 2f                	cmp    $0x2f,%al
8010256f:	74 f2                	je     80102563 <skipelem+0x91>
  return path;
80102571:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102574:	c9                   	leave  
80102575:	c3                   	ret    

80102576 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102576:	f3 0f 1e fb          	endbr32 
8010257a:	55                   	push   %ebp
8010257b:	89 e5                	mov    %esp,%ebp
8010257d:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102580:	8b 45 08             	mov    0x8(%ebp),%eax
80102583:	0f b6 00             	movzbl (%eax),%eax
80102586:	3c 2f                	cmp    $0x2f,%al
80102588:	75 17                	jne    801025a1 <namex+0x2b>
    ip = iget(ROOTDEV, ROOTINO);
8010258a:	83 ec 08             	sub    $0x8,%esp
8010258d:	6a 01                	push   $0x1
8010258f:	6a 01                	push   $0x1
80102591:	e8 74 f4 ff ff       	call   80101a0a <iget>
80102596:	83 c4 10             	add    $0x10,%esp
80102599:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010259c:	e9 ba 00 00 00       	jmp    8010265b <namex+0xe5>
  else
    ip = idup(myproc()->cwd);
801025a1:	e8 b0 1f 00 00       	call   80104556 <myproc>
801025a6:	8b 40 68             	mov    0x68(%eax),%eax
801025a9:	83 ec 0c             	sub    $0xc,%esp
801025ac:	50                   	push   %eax
801025ad:	e8 3e f5 ff ff       	call   80101af0 <idup>
801025b2:	83 c4 10             	add    $0x10,%esp
801025b5:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801025b8:	e9 9e 00 00 00       	jmp    8010265b <namex+0xe5>
    ilock(ip);
801025bd:	83 ec 0c             	sub    $0xc,%esp
801025c0:	ff 75 f4             	pushl  -0xc(%ebp)
801025c3:	e8 66 f5 ff ff       	call   80101b2e <ilock>
801025c8:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
801025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025ce:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801025d2:	66 83 f8 01          	cmp    $0x1,%ax
801025d6:	74 18                	je     801025f0 <namex+0x7a>
      iunlockput(ip);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	ff 75 f4             	pushl  -0xc(%ebp)
801025de:	e8 88 f7 ff ff       	call   80101d6b <iunlockput>
801025e3:	83 c4 10             	add    $0x10,%esp
      return 0;
801025e6:	b8 00 00 00 00       	mov    $0x0,%eax
801025eb:	e9 a7 00 00 00       	jmp    80102697 <namex+0x121>
    }
    if(nameiparent && *path == '\0'){
801025f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801025f4:	74 20                	je     80102616 <namex+0xa0>
801025f6:	8b 45 08             	mov    0x8(%ebp),%eax
801025f9:	0f b6 00             	movzbl (%eax),%eax
801025fc:	84 c0                	test   %al,%al
801025fe:	75 16                	jne    80102616 <namex+0xa0>
      // Stop one level early.
      iunlock(ip);
80102600:	83 ec 0c             	sub    $0xc,%esp
80102603:	ff 75 f4             	pushl  -0xc(%ebp)
80102606:	e8 3a f6 ff ff       	call   80101c45 <iunlock>
8010260b:	83 c4 10             	add    $0x10,%esp
      return ip;
8010260e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102611:	e9 81 00 00 00       	jmp    80102697 <namex+0x121>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102616:	83 ec 04             	sub    $0x4,%esp
80102619:	6a 00                	push   $0x0
8010261b:	ff 75 10             	pushl  0x10(%ebp)
8010261e:	ff 75 f4             	pushl  -0xc(%ebp)
80102621:	e8 12 fd ff ff       	call   80102338 <dirlookup>
80102626:	83 c4 10             	add    $0x10,%esp
80102629:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010262c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102630:	75 15                	jne    80102647 <namex+0xd1>
      iunlockput(ip);
80102632:	83 ec 0c             	sub    $0xc,%esp
80102635:	ff 75 f4             	pushl  -0xc(%ebp)
80102638:	e8 2e f7 ff ff       	call   80101d6b <iunlockput>
8010263d:	83 c4 10             	add    $0x10,%esp
      return 0;
80102640:	b8 00 00 00 00       	mov    $0x0,%eax
80102645:	eb 50                	jmp    80102697 <namex+0x121>
    }
    iunlockput(ip);
80102647:	83 ec 0c             	sub    $0xc,%esp
8010264a:	ff 75 f4             	pushl  -0xc(%ebp)
8010264d:	e8 19 f7 ff ff       	call   80101d6b <iunlockput>
80102652:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102655:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102658:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
8010265b:	83 ec 08             	sub    $0x8,%esp
8010265e:	ff 75 10             	pushl  0x10(%ebp)
80102661:	ff 75 08             	pushl  0x8(%ebp)
80102664:	e8 69 fe ff ff       	call   801024d2 <skipelem>
80102669:	83 c4 10             	add    $0x10,%esp
8010266c:	89 45 08             	mov    %eax,0x8(%ebp)
8010266f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102673:	0f 85 44 ff ff ff    	jne    801025bd <namex+0x47>
  }
  if(nameiparent){
80102679:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010267d:	74 15                	je     80102694 <namex+0x11e>
    iput(ip);
8010267f:	83 ec 0c             	sub    $0xc,%esp
80102682:	ff 75 f4             	pushl  -0xc(%ebp)
80102685:	e8 0d f6 ff ff       	call   80101c97 <iput>
8010268a:	83 c4 10             	add    $0x10,%esp
    return 0;
8010268d:	b8 00 00 00 00       	mov    $0x0,%eax
80102692:	eb 03                	jmp    80102697 <namex+0x121>
  }
  return ip;
80102694:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102697:	c9                   	leave  
80102698:	c3                   	ret    

80102699 <namei>:

struct inode*
namei(char *path)
{
80102699:	f3 0f 1e fb          	endbr32 
8010269d:	55                   	push   %ebp
8010269e:	89 e5                	mov    %esp,%ebp
801026a0:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801026a3:	83 ec 04             	sub    $0x4,%esp
801026a6:	8d 45 ea             	lea    -0x16(%ebp),%eax
801026a9:	50                   	push   %eax
801026aa:	6a 00                	push   $0x0
801026ac:	ff 75 08             	pushl  0x8(%ebp)
801026af:	e8 c2 fe ff ff       	call   80102576 <namex>
801026b4:	83 c4 10             	add    $0x10,%esp
}
801026b7:	c9                   	leave  
801026b8:	c3                   	ret    

801026b9 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801026b9:	f3 0f 1e fb          	endbr32 
801026bd:	55                   	push   %ebp
801026be:	89 e5                	mov    %esp,%ebp
801026c0:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801026c3:	83 ec 04             	sub    $0x4,%esp
801026c6:	ff 75 0c             	pushl  0xc(%ebp)
801026c9:	6a 01                	push   $0x1
801026cb:	ff 75 08             	pushl  0x8(%ebp)
801026ce:	e8 a3 fe ff ff       	call   80102576 <namex>
801026d3:	83 c4 10             	add    $0x10,%esp
}
801026d6:	c9                   	leave  
801026d7:	c3                   	ret    

801026d8 <inb>:
{
801026d8:	55                   	push   %ebp
801026d9:	89 e5                	mov    %esp,%ebp
801026db:	83 ec 14             	sub    $0x14,%esp
801026de:	8b 45 08             	mov    0x8(%ebp),%eax
801026e1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026e5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801026e9:	89 c2                	mov    %eax,%edx
801026eb:	ec                   	in     (%dx),%al
801026ec:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801026ef:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801026f3:	c9                   	leave  
801026f4:	c3                   	ret    

801026f5 <insl>:
{
801026f5:	55                   	push   %ebp
801026f6:	89 e5                	mov    %esp,%ebp
801026f8:	57                   	push   %edi
801026f9:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801026fa:	8b 55 08             	mov    0x8(%ebp),%edx
801026fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102700:	8b 45 10             	mov    0x10(%ebp),%eax
80102703:	89 cb                	mov    %ecx,%ebx
80102705:	89 df                	mov    %ebx,%edi
80102707:	89 c1                	mov    %eax,%ecx
80102709:	fc                   	cld    
8010270a:	f3 6d                	rep insl (%dx),%es:(%edi)
8010270c:	89 c8                	mov    %ecx,%eax
8010270e:	89 fb                	mov    %edi,%ebx
80102710:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102713:	89 45 10             	mov    %eax,0x10(%ebp)
}
80102716:	90                   	nop
80102717:	5b                   	pop    %ebx
80102718:	5f                   	pop    %edi
80102719:	5d                   	pop    %ebp
8010271a:	c3                   	ret    

8010271b <outb>:
{
8010271b:	55                   	push   %ebp
8010271c:	89 e5                	mov    %esp,%ebp
8010271e:	83 ec 08             	sub    $0x8,%esp
80102721:	8b 45 08             	mov    0x8(%ebp),%eax
80102724:	8b 55 0c             	mov    0xc(%ebp),%edx
80102727:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010272b:	89 d0                	mov    %edx,%eax
8010272d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102730:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102734:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102738:	ee                   	out    %al,(%dx)
}
80102739:	90                   	nop
8010273a:	c9                   	leave  
8010273b:	c3                   	ret    

8010273c <outsl>:
{
8010273c:	55                   	push   %ebp
8010273d:	89 e5                	mov    %esp,%ebp
8010273f:	56                   	push   %esi
80102740:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102741:	8b 55 08             	mov    0x8(%ebp),%edx
80102744:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102747:	8b 45 10             	mov    0x10(%ebp),%eax
8010274a:	89 cb                	mov    %ecx,%ebx
8010274c:	89 de                	mov    %ebx,%esi
8010274e:	89 c1                	mov    %eax,%ecx
80102750:	fc                   	cld    
80102751:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102753:	89 c8                	mov    %ecx,%eax
80102755:	89 f3                	mov    %esi,%ebx
80102757:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010275a:	89 45 10             	mov    %eax,0x10(%ebp)
}
8010275d:	90                   	nop
8010275e:	5b                   	pop    %ebx
8010275f:	5e                   	pop    %esi
80102760:	5d                   	pop    %ebp
80102761:	c3                   	ret    

80102762 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102762:	f3 0f 1e fb          	endbr32 
80102766:	55                   	push   %ebp
80102767:	89 e5                	mov    %esp,%ebp
80102769:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010276c:	90                   	nop
8010276d:	68 f7 01 00 00       	push   $0x1f7
80102772:	e8 61 ff ff ff       	call   801026d8 <inb>
80102777:	83 c4 04             	add    $0x4,%esp
8010277a:	0f b6 c0             	movzbl %al,%eax
8010277d:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102780:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102783:	25 c0 00 00 00       	and    $0xc0,%eax
80102788:	83 f8 40             	cmp    $0x40,%eax
8010278b:	75 e0                	jne    8010276d <idewait+0xb>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010278d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102791:	74 11                	je     801027a4 <idewait+0x42>
80102793:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102796:	83 e0 21             	and    $0x21,%eax
80102799:	85 c0                	test   %eax,%eax
8010279b:	74 07                	je     801027a4 <idewait+0x42>
    return -1;
8010279d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801027a2:	eb 05                	jmp    801027a9 <idewait+0x47>
  return 0;
801027a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801027a9:	c9                   	leave  
801027aa:	c3                   	ret    

801027ab <ideinit>:

void
ideinit(void)
{
801027ab:	f3 0f 1e fb          	endbr32 
801027af:	55                   	push   %ebp
801027b0:	89 e5                	mov    %esp,%ebp
801027b2:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
801027b5:	83 ec 08             	sub    $0x8,%esp
801027b8:	68 f3 99 10 80       	push   $0x801099f3
801027bd:	68 00 d6 10 80       	push   $0x8010d600
801027c2:	e8 bf 2d 00 00       	call   80105586 <initlock>
801027c7:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801027ca:	a1 a0 5d 11 80       	mov    0x80115da0,%eax
801027cf:	83 e8 01             	sub    $0x1,%eax
801027d2:	83 ec 08             	sub    $0x8,%esp
801027d5:	50                   	push   %eax
801027d6:	6a 0e                	push   $0xe
801027d8:	e8 bb 04 00 00       	call   80102c98 <ioapicenable>
801027dd:	83 c4 10             	add    $0x10,%esp
  idewait(0);
801027e0:	83 ec 0c             	sub    $0xc,%esp
801027e3:	6a 00                	push   $0x0
801027e5:	e8 78 ff ff ff       	call   80102762 <idewait>
801027ea:	83 c4 10             	add    $0x10,%esp

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801027ed:	83 ec 08             	sub    $0x8,%esp
801027f0:	68 f0 00 00 00       	push   $0xf0
801027f5:	68 f6 01 00 00       	push   $0x1f6
801027fa:	e8 1c ff ff ff       	call   8010271b <outb>
801027ff:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102802:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102809:	eb 24                	jmp    8010282f <ideinit+0x84>
    if(inb(0x1f7) != 0){
8010280b:	83 ec 0c             	sub    $0xc,%esp
8010280e:	68 f7 01 00 00       	push   $0x1f7
80102813:	e8 c0 fe ff ff       	call   801026d8 <inb>
80102818:	83 c4 10             	add    $0x10,%esp
8010281b:	84 c0                	test   %al,%al
8010281d:	74 0c                	je     8010282b <ideinit+0x80>
      havedisk1 = 1;
8010281f:	c7 05 38 d6 10 80 01 	movl   $0x1,0x8010d638
80102826:	00 00 00 
      break;
80102829:	eb 0d                	jmp    80102838 <ideinit+0x8d>
  for(i=0; i<1000; i++){
8010282b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010282f:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102836:	7e d3                	jle    8010280b <ideinit+0x60>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102838:	83 ec 08             	sub    $0x8,%esp
8010283b:	68 e0 00 00 00       	push   $0xe0
80102840:	68 f6 01 00 00       	push   $0x1f6
80102845:	e8 d1 fe ff ff       	call   8010271b <outb>
8010284a:	83 c4 10             	add    $0x10,%esp
}
8010284d:	90                   	nop
8010284e:	c9                   	leave  
8010284f:	c3                   	ret    

80102850 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102850:	f3 0f 1e fb          	endbr32 
80102854:	55                   	push   %ebp
80102855:	89 e5                	mov    %esp,%ebp
80102857:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
8010285a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010285e:	75 0d                	jne    8010286d <idestart+0x1d>
    panic("idestart");
80102860:	83 ec 0c             	sub    $0xc,%esp
80102863:	68 f7 99 10 80       	push   $0x801099f7
80102868:	e8 9b dd ff ff       	call   80100608 <panic>
  if(b->blockno >= FSSIZE)
8010286d:	8b 45 08             	mov    0x8(%ebp),%eax
80102870:	8b 40 08             	mov    0x8(%eax),%eax
80102873:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102878:	76 0d                	jbe    80102887 <idestart+0x37>
    panic("incorrect blockno");
8010287a:	83 ec 0c             	sub    $0xc,%esp
8010287d:	68 00 9a 10 80       	push   $0x80109a00
80102882:	e8 81 dd ff ff       	call   80100608 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102887:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
8010288e:	8b 45 08             	mov    0x8(%ebp),%eax
80102891:	8b 50 08             	mov    0x8(%eax),%edx
80102894:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102897:	0f af c2             	imul   %edx,%eax
8010289a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
8010289d:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
801028a1:	75 07                	jne    801028aa <idestart+0x5a>
801028a3:	b8 20 00 00 00       	mov    $0x20,%eax
801028a8:	eb 05                	jmp    801028af <idestart+0x5f>
801028aa:	b8 c4 00 00 00       	mov    $0xc4,%eax
801028af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
801028b2:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
801028b6:	75 07                	jne    801028bf <idestart+0x6f>
801028b8:	b8 30 00 00 00       	mov    $0x30,%eax
801028bd:	eb 05                	jmp    801028c4 <idestart+0x74>
801028bf:	b8 c5 00 00 00       	mov    $0xc5,%eax
801028c4:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
801028c7:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801028cb:	7e 0d                	jle    801028da <idestart+0x8a>
801028cd:	83 ec 0c             	sub    $0xc,%esp
801028d0:	68 f7 99 10 80       	push   $0x801099f7
801028d5:	e8 2e dd ff ff       	call   80100608 <panic>

  idewait(0);
801028da:	83 ec 0c             	sub    $0xc,%esp
801028dd:	6a 00                	push   $0x0
801028df:	e8 7e fe ff ff       	call   80102762 <idewait>
801028e4:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
801028e7:	83 ec 08             	sub    $0x8,%esp
801028ea:	6a 00                	push   $0x0
801028ec:	68 f6 03 00 00       	push   $0x3f6
801028f1:	e8 25 fe ff ff       	call   8010271b <outb>
801028f6:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
801028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028fc:	0f b6 c0             	movzbl %al,%eax
801028ff:	83 ec 08             	sub    $0x8,%esp
80102902:	50                   	push   %eax
80102903:	68 f2 01 00 00       	push   $0x1f2
80102908:	e8 0e fe ff ff       	call   8010271b <outb>
8010290d:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102910:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102913:	0f b6 c0             	movzbl %al,%eax
80102916:	83 ec 08             	sub    $0x8,%esp
80102919:	50                   	push   %eax
8010291a:	68 f3 01 00 00       	push   $0x1f3
8010291f:	e8 f7 fd ff ff       	call   8010271b <outb>
80102924:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102927:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010292a:	c1 f8 08             	sar    $0x8,%eax
8010292d:	0f b6 c0             	movzbl %al,%eax
80102930:	83 ec 08             	sub    $0x8,%esp
80102933:	50                   	push   %eax
80102934:	68 f4 01 00 00       	push   $0x1f4
80102939:	e8 dd fd ff ff       	call   8010271b <outb>
8010293e:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102941:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102944:	c1 f8 10             	sar    $0x10,%eax
80102947:	0f b6 c0             	movzbl %al,%eax
8010294a:	83 ec 08             	sub    $0x8,%esp
8010294d:	50                   	push   %eax
8010294e:	68 f5 01 00 00       	push   $0x1f5
80102953:	e8 c3 fd ff ff       	call   8010271b <outb>
80102958:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010295b:	8b 45 08             	mov    0x8(%ebp),%eax
8010295e:	8b 40 04             	mov    0x4(%eax),%eax
80102961:	c1 e0 04             	shl    $0x4,%eax
80102964:	83 e0 10             	and    $0x10,%eax
80102967:	89 c2                	mov    %eax,%edx
80102969:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010296c:	c1 f8 18             	sar    $0x18,%eax
8010296f:	83 e0 0f             	and    $0xf,%eax
80102972:	09 d0                	or     %edx,%eax
80102974:	83 c8 e0             	or     $0xffffffe0,%eax
80102977:	0f b6 c0             	movzbl %al,%eax
8010297a:	83 ec 08             	sub    $0x8,%esp
8010297d:	50                   	push   %eax
8010297e:	68 f6 01 00 00       	push   $0x1f6
80102983:	e8 93 fd ff ff       	call   8010271b <outb>
80102988:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
8010298b:	8b 45 08             	mov    0x8(%ebp),%eax
8010298e:	8b 00                	mov    (%eax),%eax
80102990:	83 e0 04             	and    $0x4,%eax
80102993:	85 c0                	test   %eax,%eax
80102995:	74 35                	je     801029cc <idestart+0x17c>
    outb(0x1f7, write_cmd);
80102997:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010299a:	0f b6 c0             	movzbl %al,%eax
8010299d:	83 ec 08             	sub    $0x8,%esp
801029a0:	50                   	push   %eax
801029a1:	68 f7 01 00 00       	push   $0x1f7
801029a6:	e8 70 fd ff ff       	call   8010271b <outb>
801029ab:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
801029ae:	8b 45 08             	mov    0x8(%ebp),%eax
801029b1:	83 c0 5c             	add    $0x5c,%eax
801029b4:	83 ec 04             	sub    $0x4,%esp
801029b7:	68 80 00 00 00       	push   $0x80
801029bc:	50                   	push   %eax
801029bd:	68 f0 01 00 00       	push   $0x1f0
801029c2:	e8 75 fd ff ff       	call   8010273c <outsl>
801029c7:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, read_cmd);
  }
}
801029ca:	eb 17                	jmp    801029e3 <idestart+0x193>
    outb(0x1f7, read_cmd);
801029cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801029cf:	0f b6 c0             	movzbl %al,%eax
801029d2:	83 ec 08             	sub    $0x8,%esp
801029d5:	50                   	push   %eax
801029d6:	68 f7 01 00 00       	push   $0x1f7
801029db:	e8 3b fd ff ff       	call   8010271b <outb>
801029e0:	83 c4 10             	add    $0x10,%esp
}
801029e3:	90                   	nop
801029e4:	c9                   	leave  
801029e5:	c3                   	ret    

801029e6 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801029e6:	f3 0f 1e fb          	endbr32 
801029ea:	55                   	push   %ebp
801029eb:	89 e5                	mov    %esp,%ebp
801029ed:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801029f0:	83 ec 0c             	sub    $0xc,%esp
801029f3:	68 00 d6 10 80       	push   $0x8010d600
801029f8:	e8 af 2b 00 00       	call   801055ac <acquire>
801029fd:	83 c4 10             	add    $0x10,%esp

  if((b = idequeue) == 0){
80102a00:	a1 34 d6 10 80       	mov    0x8010d634,%eax
80102a05:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102a0c:	75 15                	jne    80102a23 <ideintr+0x3d>
    release(&idelock);
80102a0e:	83 ec 0c             	sub    $0xc,%esp
80102a11:	68 00 d6 10 80       	push   $0x8010d600
80102a16:	e8 03 2c 00 00       	call   8010561e <release>
80102a1b:	83 c4 10             	add    $0x10,%esp
    return;
80102a1e:	e9 9a 00 00 00       	jmp    80102abd <ideintr+0xd7>
  }
  idequeue = b->qnext;
80102a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a26:	8b 40 58             	mov    0x58(%eax),%eax
80102a29:	a3 34 d6 10 80       	mov    %eax,0x8010d634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a31:	8b 00                	mov    (%eax),%eax
80102a33:	83 e0 04             	and    $0x4,%eax
80102a36:	85 c0                	test   %eax,%eax
80102a38:	75 2d                	jne    80102a67 <ideintr+0x81>
80102a3a:	83 ec 0c             	sub    $0xc,%esp
80102a3d:	6a 01                	push   $0x1
80102a3f:	e8 1e fd ff ff       	call   80102762 <idewait>
80102a44:	83 c4 10             	add    $0x10,%esp
80102a47:	85 c0                	test   %eax,%eax
80102a49:	78 1c                	js     80102a67 <ideintr+0x81>
    insl(0x1f0, b->data, BSIZE/4);
80102a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a4e:	83 c0 5c             	add    $0x5c,%eax
80102a51:	83 ec 04             	sub    $0x4,%esp
80102a54:	68 80 00 00 00       	push   $0x80
80102a59:	50                   	push   %eax
80102a5a:	68 f0 01 00 00       	push   $0x1f0
80102a5f:	e8 91 fc ff ff       	call   801026f5 <insl>
80102a64:	83 c4 10             	add    $0x10,%esp

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a6a:	8b 00                	mov    (%eax),%eax
80102a6c:	83 c8 02             	or     $0x2,%eax
80102a6f:	89 c2                	mov    %eax,%edx
80102a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a74:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a79:	8b 00                	mov    (%eax),%eax
80102a7b:	83 e0 fb             	and    $0xfffffffb,%eax
80102a7e:	89 c2                	mov    %eax,%edx
80102a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a83:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102a85:	83 ec 0c             	sub    $0xc,%esp
80102a88:	ff 75 f4             	pushl  -0xc(%ebp)
80102a8b:	e8 9c 27 00 00       	call   8010522c <wakeup>
80102a90:	83 c4 10             	add    $0x10,%esp

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102a93:	a1 34 d6 10 80       	mov    0x8010d634,%eax
80102a98:	85 c0                	test   %eax,%eax
80102a9a:	74 11                	je     80102aad <ideintr+0xc7>
    idestart(idequeue);
80102a9c:	a1 34 d6 10 80       	mov    0x8010d634,%eax
80102aa1:	83 ec 0c             	sub    $0xc,%esp
80102aa4:	50                   	push   %eax
80102aa5:	e8 a6 fd ff ff       	call   80102850 <idestart>
80102aaa:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102aad:	83 ec 0c             	sub    $0xc,%esp
80102ab0:	68 00 d6 10 80       	push   $0x8010d600
80102ab5:	e8 64 2b 00 00       	call   8010561e <release>
80102aba:	83 c4 10             	add    $0x10,%esp
}
80102abd:	c9                   	leave  
80102abe:	c3                   	ret    

80102abf <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102abf:	f3 0f 1e fb          	endbr32 
80102ac3:	55                   	push   %ebp
80102ac4:	89 e5                	mov    %esp,%ebp
80102ac6:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102ac9:	8b 45 08             	mov    0x8(%ebp),%eax
80102acc:	83 c0 0c             	add    $0xc,%eax
80102acf:	83 ec 0c             	sub    $0xc,%esp
80102ad2:	50                   	push   %eax
80102ad3:	e8 15 2a 00 00       	call   801054ed <holdingsleep>
80102ad8:	83 c4 10             	add    $0x10,%esp
80102adb:	85 c0                	test   %eax,%eax
80102add:	75 0d                	jne    80102aec <iderw+0x2d>
    panic("iderw: buf not locked");
80102adf:	83 ec 0c             	sub    $0xc,%esp
80102ae2:	68 12 9a 10 80       	push   $0x80109a12
80102ae7:	e8 1c db ff ff       	call   80100608 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102aec:	8b 45 08             	mov    0x8(%ebp),%eax
80102aef:	8b 00                	mov    (%eax),%eax
80102af1:	83 e0 06             	and    $0x6,%eax
80102af4:	83 f8 02             	cmp    $0x2,%eax
80102af7:	75 0d                	jne    80102b06 <iderw+0x47>
    panic("iderw: nothing to do");
80102af9:	83 ec 0c             	sub    $0xc,%esp
80102afc:	68 28 9a 10 80       	push   $0x80109a28
80102b01:	e8 02 db ff ff       	call   80100608 <panic>
  if(b->dev != 0 && !havedisk1)
80102b06:	8b 45 08             	mov    0x8(%ebp),%eax
80102b09:	8b 40 04             	mov    0x4(%eax),%eax
80102b0c:	85 c0                	test   %eax,%eax
80102b0e:	74 16                	je     80102b26 <iderw+0x67>
80102b10:	a1 38 d6 10 80       	mov    0x8010d638,%eax
80102b15:	85 c0                	test   %eax,%eax
80102b17:	75 0d                	jne    80102b26 <iderw+0x67>
    panic("iderw: ide disk 1 not present");
80102b19:	83 ec 0c             	sub    $0xc,%esp
80102b1c:	68 3d 9a 10 80       	push   $0x80109a3d
80102b21:	e8 e2 da ff ff       	call   80100608 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102b26:	83 ec 0c             	sub    $0xc,%esp
80102b29:	68 00 d6 10 80       	push   $0x8010d600
80102b2e:	e8 79 2a 00 00       	call   801055ac <acquire>
80102b33:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102b36:	8b 45 08             	mov    0x8(%ebp),%eax
80102b39:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102b40:	c7 45 f4 34 d6 10 80 	movl   $0x8010d634,-0xc(%ebp)
80102b47:	eb 0b                	jmp    80102b54 <iderw+0x95>
80102b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b4c:	8b 00                	mov    (%eax),%eax
80102b4e:	83 c0 58             	add    $0x58,%eax
80102b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b57:	8b 00                	mov    (%eax),%eax
80102b59:	85 c0                	test   %eax,%eax
80102b5b:	75 ec                	jne    80102b49 <iderw+0x8a>
    ;
  *pp = b;
80102b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b60:	8b 55 08             	mov    0x8(%ebp),%edx
80102b63:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
80102b65:	a1 34 d6 10 80       	mov    0x8010d634,%eax
80102b6a:	39 45 08             	cmp    %eax,0x8(%ebp)
80102b6d:	75 23                	jne    80102b92 <iderw+0xd3>
    idestart(b);
80102b6f:	83 ec 0c             	sub    $0xc,%esp
80102b72:	ff 75 08             	pushl  0x8(%ebp)
80102b75:	e8 d6 fc ff ff       	call   80102850 <idestart>
80102b7a:	83 c4 10             	add    $0x10,%esp

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102b7d:	eb 13                	jmp    80102b92 <iderw+0xd3>
    sleep(b, &idelock);
80102b7f:	83 ec 08             	sub    $0x8,%esp
80102b82:	68 00 d6 10 80       	push   $0x8010d600
80102b87:	ff 75 08             	pushl  0x8(%ebp)
80102b8a:	e8 ab 25 00 00       	call   8010513a <sleep>
80102b8f:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102b92:	8b 45 08             	mov    0x8(%ebp),%eax
80102b95:	8b 00                	mov    (%eax),%eax
80102b97:	83 e0 06             	and    $0x6,%eax
80102b9a:	83 f8 02             	cmp    $0x2,%eax
80102b9d:	75 e0                	jne    80102b7f <iderw+0xc0>
  }


  release(&idelock);
80102b9f:	83 ec 0c             	sub    $0xc,%esp
80102ba2:	68 00 d6 10 80       	push   $0x8010d600
80102ba7:	e8 72 2a 00 00       	call   8010561e <release>
80102bac:	83 c4 10             	add    $0x10,%esp
}
80102baf:	90                   	nop
80102bb0:	c9                   	leave  
80102bb1:	c3                   	ret    

80102bb2 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102bb2:	f3 0f 1e fb          	endbr32 
80102bb6:	55                   	push   %ebp
80102bb7:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102bb9:	a1 d4 56 11 80       	mov    0x801156d4,%eax
80102bbe:	8b 55 08             	mov    0x8(%ebp),%edx
80102bc1:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102bc3:	a1 d4 56 11 80       	mov    0x801156d4,%eax
80102bc8:	8b 40 10             	mov    0x10(%eax),%eax
}
80102bcb:	5d                   	pop    %ebp
80102bcc:	c3                   	ret    

80102bcd <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102bcd:	f3 0f 1e fb          	endbr32 
80102bd1:	55                   	push   %ebp
80102bd2:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102bd4:	a1 d4 56 11 80       	mov    0x801156d4,%eax
80102bd9:	8b 55 08             	mov    0x8(%ebp),%edx
80102bdc:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102bde:	a1 d4 56 11 80       	mov    0x801156d4,%eax
80102be3:	8b 55 0c             	mov    0xc(%ebp),%edx
80102be6:	89 50 10             	mov    %edx,0x10(%eax)
}
80102be9:	90                   	nop
80102bea:	5d                   	pop    %ebp
80102beb:	c3                   	ret    

80102bec <ioapicinit>:

void
ioapicinit(void)
{
80102bec:	f3 0f 1e fb          	endbr32 
80102bf0:	55                   	push   %ebp
80102bf1:	89 e5                	mov    %esp,%ebp
80102bf3:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102bf6:	c7 05 d4 56 11 80 00 	movl   $0xfec00000,0x801156d4
80102bfd:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102c00:	6a 01                	push   $0x1
80102c02:	e8 ab ff ff ff       	call   80102bb2 <ioapicread>
80102c07:	83 c4 04             	add    $0x4,%esp
80102c0a:	c1 e8 10             	shr    $0x10,%eax
80102c0d:	25 ff 00 00 00       	and    $0xff,%eax
80102c12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102c15:	6a 00                	push   $0x0
80102c17:	e8 96 ff ff ff       	call   80102bb2 <ioapicread>
80102c1c:	83 c4 04             	add    $0x4,%esp
80102c1f:	c1 e8 18             	shr    $0x18,%eax
80102c22:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102c25:	0f b6 05 00 58 11 80 	movzbl 0x80115800,%eax
80102c2c:	0f b6 c0             	movzbl %al,%eax
80102c2f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80102c32:	74 10                	je     80102c44 <ioapicinit+0x58>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102c34:	83 ec 0c             	sub    $0xc,%esp
80102c37:	68 5c 9a 10 80       	push   $0x80109a5c
80102c3c:	e8 d7 d7 ff ff       	call   80100418 <cprintf>
80102c41:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102c44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102c4b:	eb 3f                	jmp    80102c8c <ioapicinit+0xa0>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c50:	83 c0 20             	add    $0x20,%eax
80102c53:	0d 00 00 01 00       	or     $0x10000,%eax
80102c58:	89 c2                	mov    %eax,%edx
80102c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c5d:	83 c0 08             	add    $0x8,%eax
80102c60:	01 c0                	add    %eax,%eax
80102c62:	83 ec 08             	sub    $0x8,%esp
80102c65:	52                   	push   %edx
80102c66:	50                   	push   %eax
80102c67:	e8 61 ff ff ff       	call   80102bcd <ioapicwrite>
80102c6c:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c72:	83 c0 08             	add    $0x8,%eax
80102c75:	01 c0                	add    %eax,%eax
80102c77:	83 c0 01             	add    $0x1,%eax
80102c7a:	83 ec 08             	sub    $0x8,%esp
80102c7d:	6a 00                	push   $0x0
80102c7f:	50                   	push   %eax
80102c80:	e8 48 ff ff ff       	call   80102bcd <ioapicwrite>
80102c85:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
80102c88:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c8f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102c92:	7e b9                	jle    80102c4d <ioapicinit+0x61>
  }
}
80102c94:	90                   	nop
80102c95:	90                   	nop
80102c96:	c9                   	leave  
80102c97:	c3                   	ret    

80102c98 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102c98:	f3 0f 1e fb          	endbr32 
80102c9c:	55                   	push   %ebp
80102c9d:	89 e5                	mov    %esp,%ebp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102c9f:	8b 45 08             	mov    0x8(%ebp),%eax
80102ca2:	83 c0 20             	add    $0x20,%eax
80102ca5:	89 c2                	mov    %eax,%edx
80102ca7:	8b 45 08             	mov    0x8(%ebp),%eax
80102caa:	83 c0 08             	add    $0x8,%eax
80102cad:	01 c0                	add    %eax,%eax
80102caf:	52                   	push   %edx
80102cb0:	50                   	push   %eax
80102cb1:	e8 17 ff ff ff       	call   80102bcd <ioapicwrite>
80102cb6:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
80102cbc:	c1 e0 18             	shl    $0x18,%eax
80102cbf:	89 c2                	mov    %eax,%edx
80102cc1:	8b 45 08             	mov    0x8(%ebp),%eax
80102cc4:	83 c0 08             	add    $0x8,%eax
80102cc7:	01 c0                	add    %eax,%eax
80102cc9:	83 c0 01             	add    $0x1,%eax
80102ccc:	52                   	push   %edx
80102ccd:	50                   	push   %eax
80102cce:	e8 fa fe ff ff       	call   80102bcd <ioapicwrite>
80102cd3:	83 c4 08             	add    $0x8,%esp
}
80102cd6:	90                   	nop
80102cd7:	c9                   	leave  
80102cd8:	c3                   	ret    

80102cd9 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102cd9:	f3 0f 1e fb          	endbr32 
80102cdd:	55                   	push   %ebp
80102cde:	89 e5                	mov    %esp,%ebp
80102ce0:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102ce3:	83 ec 08             	sub    $0x8,%esp
80102ce6:	68 8e 9a 10 80       	push   $0x80109a8e
80102ceb:	68 e0 56 11 80       	push   $0x801156e0
80102cf0:	e8 91 28 00 00       	call   80105586 <initlock>
80102cf5:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102cf8:	c7 05 14 57 11 80 00 	movl   $0x0,0x80115714
80102cff:	00 00 00 
  freerange(vstart, vend);
80102d02:	83 ec 08             	sub    $0x8,%esp
80102d05:	ff 75 0c             	pushl  0xc(%ebp)
80102d08:	ff 75 08             	pushl  0x8(%ebp)
80102d0b:	e8 2e 00 00 00       	call   80102d3e <freerange>
80102d10:	83 c4 10             	add    $0x10,%esp
}
80102d13:	90                   	nop
80102d14:	c9                   	leave  
80102d15:	c3                   	ret    

80102d16 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102d16:	f3 0f 1e fb          	endbr32 
80102d1a:	55                   	push   %ebp
80102d1b:	89 e5                	mov    %esp,%ebp
80102d1d:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102d20:	83 ec 08             	sub    $0x8,%esp
80102d23:	ff 75 0c             	pushl  0xc(%ebp)
80102d26:	ff 75 08             	pushl  0x8(%ebp)
80102d29:	e8 10 00 00 00       	call   80102d3e <freerange>
80102d2e:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102d31:	c7 05 14 57 11 80 01 	movl   $0x1,0x80115714
80102d38:	00 00 00 
}
80102d3b:	90                   	nop
80102d3c:	c9                   	leave  
80102d3d:	c3                   	ret    

80102d3e <freerange>:

void
freerange(void *vstart, void *vend)
{
80102d3e:	f3 0f 1e fb          	endbr32 
80102d42:	55                   	push   %ebp
80102d43:	89 e5                	mov    %esp,%ebp
80102d45:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102d48:	8b 45 08             	mov    0x8(%ebp),%eax
80102d4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80102d50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102d55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d58:	eb 15                	jmp    80102d6f <freerange+0x31>
    kfree(p);
80102d5a:	83 ec 0c             	sub    $0xc,%esp
80102d5d:	ff 75 f4             	pushl  -0xc(%ebp)
80102d60:	e8 1b 00 00 00       	call   80102d80 <kfree>
80102d65:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d68:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d72:	05 00 10 00 00       	add    $0x1000,%eax
80102d77:	39 45 0c             	cmp    %eax,0xc(%ebp)
80102d7a:	73 de                	jae    80102d5a <freerange+0x1c>
}
80102d7c:	90                   	nop
80102d7d:	90                   	nop
80102d7e:	c9                   	leave  
80102d7f:	c3                   	ret    

80102d80 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102d80:	f3 0f 1e fb          	endbr32 
80102d84:	55                   	push   %ebp
80102d85:	89 e5                	mov    %esp,%ebp
80102d87:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102d8a:	8b 45 08             	mov    0x8(%ebp),%eax
80102d8d:	25 ff 0f 00 00       	and    $0xfff,%eax
80102d92:	85 c0                	test   %eax,%eax
80102d94:	75 18                	jne    80102dae <kfree+0x2e>
80102d96:	81 7d 08 48 9f 11 80 	cmpl   $0x80119f48,0x8(%ebp)
80102d9d:	72 0f                	jb     80102dae <kfree+0x2e>
80102d9f:	8b 45 08             	mov    0x8(%ebp),%eax
80102da2:	05 00 00 00 80       	add    $0x80000000,%eax
80102da7:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102dac:	76 0d                	jbe    80102dbb <kfree+0x3b>
    panic("kfree");
80102dae:	83 ec 0c             	sub    $0xc,%esp
80102db1:	68 93 9a 10 80       	push   $0x80109a93
80102db6:	e8 4d d8 ff ff       	call   80100608 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102dbb:	83 ec 04             	sub    $0x4,%esp
80102dbe:	68 00 10 00 00       	push   $0x1000
80102dc3:	6a 01                	push   $0x1
80102dc5:	ff 75 08             	pushl  0x8(%ebp)
80102dc8:	e8 7e 2a 00 00       	call   8010584b <memset>
80102dcd:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102dd0:	a1 14 57 11 80       	mov    0x80115714,%eax
80102dd5:	85 c0                	test   %eax,%eax
80102dd7:	74 10                	je     80102de9 <kfree+0x69>
    acquire(&kmem.lock);
80102dd9:	83 ec 0c             	sub    $0xc,%esp
80102ddc:	68 e0 56 11 80       	push   $0x801156e0
80102de1:	e8 c6 27 00 00       	call   801055ac <acquire>
80102de6:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102de9:	8b 45 08             	mov    0x8(%ebp),%eax
80102dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102def:	8b 15 18 57 11 80    	mov    0x80115718,%edx
80102df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102df8:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dfd:	a3 18 57 11 80       	mov    %eax,0x80115718
  if(kmem.use_lock)
80102e02:	a1 14 57 11 80       	mov    0x80115714,%eax
80102e07:	85 c0                	test   %eax,%eax
80102e09:	74 10                	je     80102e1b <kfree+0x9b>
    release(&kmem.lock);
80102e0b:	83 ec 0c             	sub    $0xc,%esp
80102e0e:	68 e0 56 11 80       	push   $0x801156e0
80102e13:	e8 06 28 00 00       	call   8010561e <release>
80102e18:	83 c4 10             	add    $0x10,%esp
}
80102e1b:	90                   	nop
80102e1c:	c9                   	leave  
80102e1d:	c3                   	ret    

80102e1e <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102e1e:	f3 0f 1e fb          	endbr32 
80102e22:	55                   	push   %ebp
80102e23:	89 e5                	mov    %esp,%ebp
80102e25:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102e28:	a1 14 57 11 80       	mov    0x80115714,%eax
80102e2d:	85 c0                	test   %eax,%eax
80102e2f:	74 10                	je     80102e41 <kalloc+0x23>
    acquire(&kmem.lock);
80102e31:	83 ec 0c             	sub    $0xc,%esp
80102e34:	68 e0 56 11 80       	push   $0x801156e0
80102e39:	e8 6e 27 00 00       	call   801055ac <acquire>
80102e3e:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102e41:	a1 18 57 11 80       	mov    0x80115718,%eax
80102e46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102e49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102e4d:	74 0a                	je     80102e59 <kalloc+0x3b>
    kmem.freelist = r->next;
80102e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e52:	8b 00                	mov    (%eax),%eax
80102e54:	a3 18 57 11 80       	mov    %eax,0x80115718
  if(kmem.use_lock)
80102e59:	a1 14 57 11 80       	mov    0x80115714,%eax
80102e5e:	85 c0                	test   %eax,%eax
80102e60:	74 10                	je     80102e72 <kalloc+0x54>
    release(&kmem.lock);
80102e62:	83 ec 0c             	sub    $0xc,%esp
80102e65:	68 e0 56 11 80       	push   $0x801156e0
80102e6a:	e8 af 27 00 00       	call   8010561e <release>
80102e6f:	83 c4 10             	add    $0x10,%esp
  // cprintf("p4Debug : kalloc returns %d %x\n", PPN(V2P(r)), V2P(r));
  return (char*)r;
80102e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102e75:	c9                   	leave  
80102e76:	c3                   	ret    

80102e77 <inb>:
{
80102e77:	55                   	push   %ebp
80102e78:	89 e5                	mov    %esp,%ebp
80102e7a:	83 ec 14             	sub    $0x14,%esp
80102e7d:	8b 45 08             	mov    0x8(%ebp),%eax
80102e80:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e84:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e88:	89 c2                	mov    %eax,%edx
80102e8a:	ec                   	in     (%dx),%al
80102e8b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e8e:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102e92:	c9                   	leave  
80102e93:	c3                   	ret    

80102e94 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102e94:	f3 0f 1e fb          	endbr32 
80102e98:	55                   	push   %ebp
80102e99:	89 e5                	mov    %esp,%ebp
80102e9b:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102e9e:	6a 64                	push   $0x64
80102ea0:	e8 d2 ff ff ff       	call   80102e77 <inb>
80102ea5:	83 c4 04             	add    $0x4,%esp
80102ea8:	0f b6 c0             	movzbl %al,%eax
80102eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102eb1:	83 e0 01             	and    $0x1,%eax
80102eb4:	85 c0                	test   %eax,%eax
80102eb6:	75 0a                	jne    80102ec2 <kbdgetc+0x2e>
    return -1;
80102eb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102ebd:	e9 23 01 00 00       	jmp    80102fe5 <kbdgetc+0x151>
  data = inb(KBDATAP);
80102ec2:	6a 60                	push   $0x60
80102ec4:	e8 ae ff ff ff       	call   80102e77 <inb>
80102ec9:	83 c4 04             	add    $0x4,%esp
80102ecc:	0f b6 c0             	movzbl %al,%eax
80102ecf:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102ed2:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102ed9:	75 17                	jne    80102ef2 <kbdgetc+0x5e>
    shift |= E0ESC;
80102edb:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
80102ee0:	83 c8 40             	or     $0x40,%eax
80102ee3:	a3 3c d6 10 80       	mov    %eax,0x8010d63c
    return 0;
80102ee8:	b8 00 00 00 00       	mov    $0x0,%eax
80102eed:	e9 f3 00 00 00       	jmp    80102fe5 <kbdgetc+0x151>
  } else if(data & 0x80){
80102ef2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ef5:	25 80 00 00 00       	and    $0x80,%eax
80102efa:	85 c0                	test   %eax,%eax
80102efc:	74 45                	je     80102f43 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102efe:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
80102f03:	83 e0 40             	and    $0x40,%eax
80102f06:	85 c0                	test   %eax,%eax
80102f08:	75 08                	jne    80102f12 <kbdgetc+0x7e>
80102f0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f0d:	83 e0 7f             	and    $0x7f,%eax
80102f10:	eb 03                	jmp    80102f15 <kbdgetc+0x81>
80102f12:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f15:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102f18:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f1b:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102f20:	0f b6 00             	movzbl (%eax),%eax
80102f23:	83 c8 40             	or     $0x40,%eax
80102f26:	0f b6 c0             	movzbl %al,%eax
80102f29:	f7 d0                	not    %eax
80102f2b:	89 c2                	mov    %eax,%edx
80102f2d:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
80102f32:	21 d0                	and    %edx,%eax
80102f34:	a3 3c d6 10 80       	mov    %eax,0x8010d63c
    return 0;
80102f39:	b8 00 00 00 00       	mov    $0x0,%eax
80102f3e:	e9 a2 00 00 00       	jmp    80102fe5 <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102f43:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
80102f48:	83 e0 40             	and    $0x40,%eax
80102f4b:	85 c0                	test   %eax,%eax
80102f4d:	74 14                	je     80102f63 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102f4f:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102f56:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
80102f5b:	83 e0 bf             	and    $0xffffffbf,%eax
80102f5e:	a3 3c d6 10 80       	mov    %eax,0x8010d63c
  }

  shift |= shiftcode[data];
80102f63:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f66:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102f6b:	0f b6 00             	movzbl (%eax),%eax
80102f6e:	0f b6 d0             	movzbl %al,%edx
80102f71:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
80102f76:	09 d0                	or     %edx,%eax
80102f78:	a3 3c d6 10 80       	mov    %eax,0x8010d63c
  shift ^= togglecode[data];
80102f7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f80:	05 20 b1 10 80       	add    $0x8010b120,%eax
80102f85:	0f b6 00             	movzbl (%eax),%eax
80102f88:	0f b6 d0             	movzbl %al,%edx
80102f8b:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
80102f90:	31 d0                	xor    %edx,%eax
80102f92:	a3 3c d6 10 80       	mov    %eax,0x8010d63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102f97:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
80102f9c:	83 e0 03             	and    $0x3,%eax
80102f9f:	8b 14 85 20 b5 10 80 	mov    -0x7fef4ae0(,%eax,4),%edx
80102fa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102fa9:	01 d0                	add    %edx,%eax
80102fab:	0f b6 00             	movzbl (%eax),%eax
80102fae:	0f b6 c0             	movzbl %al,%eax
80102fb1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102fb4:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
80102fb9:	83 e0 08             	and    $0x8,%eax
80102fbc:	85 c0                	test   %eax,%eax
80102fbe:	74 22                	je     80102fe2 <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102fc0:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102fc4:	76 0c                	jbe    80102fd2 <kbdgetc+0x13e>
80102fc6:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102fca:	77 06                	ja     80102fd2 <kbdgetc+0x13e>
      c += 'A' - 'a';
80102fcc:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102fd0:	eb 10                	jmp    80102fe2 <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102fd2:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102fd6:	76 0a                	jbe    80102fe2 <kbdgetc+0x14e>
80102fd8:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102fdc:	77 04                	ja     80102fe2 <kbdgetc+0x14e>
      c += 'a' - 'A';
80102fde:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102fe2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102fe5:	c9                   	leave  
80102fe6:	c3                   	ret    

80102fe7 <kbdintr>:

void
kbdintr(void)
{
80102fe7:	f3 0f 1e fb          	endbr32 
80102feb:	55                   	push   %ebp
80102fec:	89 e5                	mov    %esp,%ebp
80102fee:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102ff1:	83 ec 0c             	sub    $0xc,%esp
80102ff4:	68 94 2e 10 80       	push   $0x80102e94
80102ff9:	e8 aa d8 ff ff       	call   801008a8 <consoleintr>
80102ffe:	83 c4 10             	add    $0x10,%esp
}
80103001:	90                   	nop
80103002:	c9                   	leave  
80103003:	c3                   	ret    

80103004 <inb>:
{
80103004:	55                   	push   %ebp
80103005:	89 e5                	mov    %esp,%ebp
80103007:	83 ec 14             	sub    $0x14,%esp
8010300a:	8b 45 08             	mov    0x8(%ebp),%eax
8010300d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103011:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103015:	89 c2                	mov    %eax,%edx
80103017:	ec                   	in     (%dx),%al
80103018:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010301b:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010301f:	c9                   	leave  
80103020:	c3                   	ret    

80103021 <outb>:
{
80103021:	55                   	push   %ebp
80103022:	89 e5                	mov    %esp,%ebp
80103024:	83 ec 08             	sub    $0x8,%esp
80103027:	8b 45 08             	mov    0x8(%ebp),%eax
8010302a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010302d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103031:	89 d0                	mov    %edx,%eax
80103033:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103036:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010303a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010303e:	ee                   	out    %al,(%dx)
}
8010303f:	90                   	nop
80103040:	c9                   	leave  
80103041:	c3                   	ret    

80103042 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80103042:	f3 0f 1e fb          	endbr32 
80103046:	55                   	push   %ebp
80103047:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80103049:	a1 1c 57 11 80       	mov    0x8011571c,%eax
8010304e:	8b 55 08             	mov    0x8(%ebp),%edx
80103051:	c1 e2 02             	shl    $0x2,%edx
80103054:	01 c2                	add    %eax,%edx
80103056:	8b 45 0c             	mov    0xc(%ebp),%eax
80103059:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
8010305b:	a1 1c 57 11 80       	mov    0x8011571c,%eax
80103060:	83 c0 20             	add    $0x20,%eax
80103063:	8b 00                	mov    (%eax),%eax
}
80103065:	90                   	nop
80103066:	5d                   	pop    %ebp
80103067:	c3                   	ret    

80103068 <lapicinit>:

void
lapicinit(void)
{
80103068:	f3 0f 1e fb          	endbr32 
8010306c:	55                   	push   %ebp
8010306d:	89 e5                	mov    %esp,%ebp
  if(!lapic)
8010306f:	a1 1c 57 11 80       	mov    0x8011571c,%eax
80103074:	85 c0                	test   %eax,%eax
80103076:	0f 84 0c 01 00 00    	je     80103188 <lapicinit+0x120>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
8010307c:	68 3f 01 00 00       	push   $0x13f
80103081:	6a 3c                	push   $0x3c
80103083:	e8 ba ff ff ff       	call   80103042 <lapicw>
80103088:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
8010308b:	6a 0b                	push   $0xb
8010308d:	68 f8 00 00 00       	push   $0xf8
80103092:	e8 ab ff ff ff       	call   80103042 <lapicw>
80103097:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
8010309a:	68 20 00 02 00       	push   $0x20020
8010309f:	68 c8 00 00 00       	push   $0xc8
801030a4:	e8 99 ff ff ff       	call   80103042 <lapicw>
801030a9:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
801030ac:	68 80 96 98 00       	push   $0x989680
801030b1:	68 e0 00 00 00       	push   $0xe0
801030b6:	e8 87 ff ff ff       	call   80103042 <lapicw>
801030bb:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
801030be:	68 00 00 01 00       	push   $0x10000
801030c3:	68 d4 00 00 00       	push   $0xd4
801030c8:	e8 75 ff ff ff       	call   80103042 <lapicw>
801030cd:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
801030d0:	68 00 00 01 00       	push   $0x10000
801030d5:	68 d8 00 00 00       	push   $0xd8
801030da:	e8 63 ff ff ff       	call   80103042 <lapicw>
801030df:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801030e2:	a1 1c 57 11 80       	mov    0x8011571c,%eax
801030e7:	83 c0 30             	add    $0x30,%eax
801030ea:	8b 00                	mov    (%eax),%eax
801030ec:	c1 e8 10             	shr    $0x10,%eax
801030ef:	25 fc 00 00 00       	and    $0xfc,%eax
801030f4:	85 c0                	test   %eax,%eax
801030f6:	74 12                	je     8010310a <lapicinit+0xa2>
    lapicw(PCINT, MASKED);
801030f8:	68 00 00 01 00       	push   $0x10000
801030fd:	68 d0 00 00 00       	push   $0xd0
80103102:	e8 3b ff ff ff       	call   80103042 <lapicw>
80103107:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
8010310a:	6a 33                	push   $0x33
8010310c:	68 dc 00 00 00       	push   $0xdc
80103111:	e8 2c ff ff ff       	call   80103042 <lapicw>
80103116:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80103119:	6a 00                	push   $0x0
8010311b:	68 a0 00 00 00       	push   $0xa0
80103120:	e8 1d ff ff ff       	call   80103042 <lapicw>
80103125:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80103128:	6a 00                	push   $0x0
8010312a:	68 a0 00 00 00       	push   $0xa0
8010312f:	e8 0e ff ff ff       	call   80103042 <lapicw>
80103134:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80103137:	6a 00                	push   $0x0
80103139:	6a 2c                	push   $0x2c
8010313b:	e8 02 ff ff ff       	call   80103042 <lapicw>
80103140:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80103143:	6a 00                	push   $0x0
80103145:	68 c4 00 00 00       	push   $0xc4
8010314a:	e8 f3 fe ff ff       	call   80103042 <lapicw>
8010314f:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80103152:	68 00 85 08 00       	push   $0x88500
80103157:	68 c0 00 00 00       	push   $0xc0
8010315c:	e8 e1 fe ff ff       	call   80103042 <lapicw>
80103161:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80103164:	90                   	nop
80103165:	a1 1c 57 11 80       	mov    0x8011571c,%eax
8010316a:	05 00 03 00 00       	add    $0x300,%eax
8010316f:	8b 00                	mov    (%eax),%eax
80103171:	25 00 10 00 00       	and    $0x1000,%eax
80103176:	85 c0                	test   %eax,%eax
80103178:	75 eb                	jne    80103165 <lapicinit+0xfd>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
8010317a:	6a 00                	push   $0x0
8010317c:	6a 20                	push   $0x20
8010317e:	e8 bf fe ff ff       	call   80103042 <lapicw>
80103183:	83 c4 08             	add    $0x8,%esp
80103186:	eb 01                	jmp    80103189 <lapicinit+0x121>
    return;
80103188:	90                   	nop
}
80103189:	c9                   	leave  
8010318a:	c3                   	ret    

8010318b <lapicid>:

int
lapicid(void)
{
8010318b:	f3 0f 1e fb          	endbr32 
8010318f:	55                   	push   %ebp
80103190:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80103192:	a1 1c 57 11 80       	mov    0x8011571c,%eax
80103197:	85 c0                	test   %eax,%eax
80103199:	75 07                	jne    801031a2 <lapicid+0x17>
    return 0;
8010319b:	b8 00 00 00 00       	mov    $0x0,%eax
801031a0:	eb 0d                	jmp    801031af <lapicid+0x24>
  return lapic[ID] >> 24;
801031a2:	a1 1c 57 11 80       	mov    0x8011571c,%eax
801031a7:	83 c0 20             	add    $0x20,%eax
801031aa:	8b 00                	mov    (%eax),%eax
801031ac:	c1 e8 18             	shr    $0x18,%eax
}
801031af:	5d                   	pop    %ebp
801031b0:	c3                   	ret    

801031b1 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801031b1:	f3 0f 1e fb          	endbr32 
801031b5:	55                   	push   %ebp
801031b6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801031b8:	a1 1c 57 11 80       	mov    0x8011571c,%eax
801031bd:	85 c0                	test   %eax,%eax
801031bf:	74 0c                	je     801031cd <lapiceoi+0x1c>
    lapicw(EOI, 0);
801031c1:	6a 00                	push   $0x0
801031c3:	6a 2c                	push   $0x2c
801031c5:	e8 78 fe ff ff       	call   80103042 <lapicw>
801031ca:	83 c4 08             	add    $0x8,%esp
}
801031cd:	90                   	nop
801031ce:	c9                   	leave  
801031cf:	c3                   	ret    

801031d0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801031d0:	f3 0f 1e fb          	endbr32 
801031d4:	55                   	push   %ebp
801031d5:	89 e5                	mov    %esp,%ebp
}
801031d7:	90                   	nop
801031d8:	5d                   	pop    %ebp
801031d9:	c3                   	ret    

801031da <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801031da:	f3 0f 1e fb          	endbr32 
801031de:	55                   	push   %ebp
801031df:	89 e5                	mov    %esp,%ebp
801031e1:	83 ec 14             	sub    $0x14,%esp
801031e4:	8b 45 08             	mov    0x8(%ebp),%eax
801031e7:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801031ea:	6a 0f                	push   $0xf
801031ec:	6a 70                	push   $0x70
801031ee:	e8 2e fe ff ff       	call   80103021 <outb>
801031f3:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
801031f6:	6a 0a                	push   $0xa
801031f8:	6a 71                	push   $0x71
801031fa:	e8 22 fe ff ff       	call   80103021 <outb>
801031ff:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103202:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103209:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010320c:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103211:	8b 45 0c             	mov    0xc(%ebp),%eax
80103214:	c1 e8 04             	shr    $0x4,%eax
80103217:	89 c2                	mov    %eax,%edx
80103219:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010321c:	83 c0 02             	add    $0x2,%eax
8010321f:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103222:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103226:	c1 e0 18             	shl    $0x18,%eax
80103229:	50                   	push   %eax
8010322a:	68 c4 00 00 00       	push   $0xc4
8010322f:	e8 0e fe ff ff       	call   80103042 <lapicw>
80103234:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103237:	68 00 c5 00 00       	push   $0xc500
8010323c:	68 c0 00 00 00       	push   $0xc0
80103241:	e8 fc fd ff ff       	call   80103042 <lapicw>
80103246:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103249:	68 c8 00 00 00       	push   $0xc8
8010324e:	e8 7d ff ff ff       	call   801031d0 <microdelay>
80103253:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80103256:	68 00 85 00 00       	push   $0x8500
8010325b:	68 c0 00 00 00       	push   $0xc0
80103260:	e8 dd fd ff ff       	call   80103042 <lapicw>
80103265:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103268:	6a 64                	push   $0x64
8010326a:	e8 61 ff ff ff       	call   801031d0 <microdelay>
8010326f:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103272:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103279:	eb 3d                	jmp    801032b8 <lapicstartap+0xde>
    lapicw(ICRHI, apicid<<24);
8010327b:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010327f:	c1 e0 18             	shl    $0x18,%eax
80103282:	50                   	push   %eax
80103283:	68 c4 00 00 00       	push   $0xc4
80103288:	e8 b5 fd ff ff       	call   80103042 <lapicw>
8010328d:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103290:	8b 45 0c             	mov    0xc(%ebp),%eax
80103293:	c1 e8 0c             	shr    $0xc,%eax
80103296:	80 cc 06             	or     $0x6,%ah
80103299:	50                   	push   %eax
8010329a:	68 c0 00 00 00       	push   $0xc0
8010329f:	e8 9e fd ff ff       	call   80103042 <lapicw>
801032a4:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801032a7:	68 c8 00 00 00       	push   $0xc8
801032ac:	e8 1f ff ff ff       	call   801031d0 <microdelay>
801032b1:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
801032b4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801032b8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801032bc:	7e bd                	jle    8010327b <lapicstartap+0xa1>
  }
}
801032be:	90                   	nop
801032bf:	90                   	nop
801032c0:	c9                   	leave  
801032c1:	c3                   	ret    

801032c2 <cmos_read>:
#define MONTH   0x08
#define YEAR    0x09

static uint
cmos_read(uint reg)
{
801032c2:	f3 0f 1e fb          	endbr32 
801032c6:	55                   	push   %ebp
801032c7:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
801032c9:	8b 45 08             	mov    0x8(%ebp),%eax
801032cc:	0f b6 c0             	movzbl %al,%eax
801032cf:	50                   	push   %eax
801032d0:	6a 70                	push   $0x70
801032d2:	e8 4a fd ff ff       	call   80103021 <outb>
801032d7:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801032da:	68 c8 00 00 00       	push   $0xc8
801032df:	e8 ec fe ff ff       	call   801031d0 <microdelay>
801032e4:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801032e7:	6a 71                	push   $0x71
801032e9:	e8 16 fd ff ff       	call   80103004 <inb>
801032ee:	83 c4 04             	add    $0x4,%esp
801032f1:	0f b6 c0             	movzbl %al,%eax
}
801032f4:	c9                   	leave  
801032f5:	c3                   	ret    

801032f6 <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
801032f6:	f3 0f 1e fb          	endbr32 
801032fa:	55                   	push   %ebp
801032fb:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
801032fd:	6a 00                	push   $0x0
801032ff:	e8 be ff ff ff       	call   801032c2 <cmos_read>
80103304:	83 c4 04             	add    $0x4,%esp
80103307:	8b 55 08             	mov    0x8(%ebp),%edx
8010330a:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
8010330c:	6a 02                	push   $0x2
8010330e:	e8 af ff ff ff       	call   801032c2 <cmos_read>
80103313:	83 c4 04             	add    $0x4,%esp
80103316:	8b 55 08             	mov    0x8(%ebp),%edx
80103319:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
8010331c:	6a 04                	push   $0x4
8010331e:	e8 9f ff ff ff       	call   801032c2 <cmos_read>
80103323:	83 c4 04             	add    $0x4,%esp
80103326:	8b 55 08             	mov    0x8(%ebp),%edx
80103329:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
8010332c:	6a 07                	push   $0x7
8010332e:	e8 8f ff ff ff       	call   801032c2 <cmos_read>
80103333:	83 c4 04             	add    $0x4,%esp
80103336:	8b 55 08             	mov    0x8(%ebp),%edx
80103339:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
8010333c:	6a 08                	push   $0x8
8010333e:	e8 7f ff ff ff       	call   801032c2 <cmos_read>
80103343:	83 c4 04             	add    $0x4,%esp
80103346:	8b 55 08             	mov    0x8(%ebp),%edx
80103349:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
8010334c:	6a 09                	push   $0x9
8010334e:	e8 6f ff ff ff       	call   801032c2 <cmos_read>
80103353:	83 c4 04             	add    $0x4,%esp
80103356:	8b 55 08             	mov    0x8(%ebp),%edx
80103359:	89 42 14             	mov    %eax,0x14(%edx)
}
8010335c:	90                   	nop
8010335d:	c9                   	leave  
8010335e:	c3                   	ret    

8010335f <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
8010335f:	f3 0f 1e fb          	endbr32 
80103363:	55                   	push   %ebp
80103364:	89 e5                	mov    %esp,%ebp
80103366:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103369:	6a 0b                	push   $0xb
8010336b:	e8 52 ff ff ff       	call   801032c2 <cmos_read>
80103370:	83 c4 04             	add    $0x4,%esp
80103373:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103376:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103379:	83 e0 04             	and    $0x4,%eax
8010337c:	85 c0                	test   %eax,%eax
8010337e:	0f 94 c0             	sete   %al
80103381:	0f b6 c0             	movzbl %al,%eax
80103384:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80103387:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010338a:	50                   	push   %eax
8010338b:	e8 66 ff ff ff       	call   801032f6 <fill_rtcdate>
80103390:	83 c4 04             	add    $0x4,%esp
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103393:	6a 0a                	push   $0xa
80103395:	e8 28 ff ff ff       	call   801032c2 <cmos_read>
8010339a:	83 c4 04             	add    $0x4,%esp
8010339d:	25 80 00 00 00       	and    $0x80,%eax
801033a2:	85 c0                	test   %eax,%eax
801033a4:	75 27                	jne    801033cd <cmostime+0x6e>
        continue;
    fill_rtcdate(&t2);
801033a6:	8d 45 c0             	lea    -0x40(%ebp),%eax
801033a9:	50                   	push   %eax
801033aa:	e8 47 ff ff ff       	call   801032f6 <fill_rtcdate>
801033af:	83 c4 04             	add    $0x4,%esp
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801033b2:	83 ec 04             	sub    $0x4,%esp
801033b5:	6a 18                	push   $0x18
801033b7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801033ba:	50                   	push   %eax
801033bb:	8d 45 d8             	lea    -0x28(%ebp),%eax
801033be:	50                   	push   %eax
801033bf:	e8 f2 24 00 00       	call   801058b6 <memcmp>
801033c4:	83 c4 10             	add    $0x10,%esp
801033c7:	85 c0                	test   %eax,%eax
801033c9:	74 05                	je     801033d0 <cmostime+0x71>
801033cb:	eb ba                	jmp    80103387 <cmostime+0x28>
        continue;
801033cd:	90                   	nop
    fill_rtcdate(&t1);
801033ce:	eb b7                	jmp    80103387 <cmostime+0x28>
      break;
801033d0:	90                   	nop
  }

  // convert
  if(bcd) {
801033d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801033d5:	0f 84 b4 00 00 00    	je     8010348f <cmostime+0x130>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801033db:	8b 45 d8             	mov    -0x28(%ebp),%eax
801033de:	c1 e8 04             	shr    $0x4,%eax
801033e1:	89 c2                	mov    %eax,%edx
801033e3:	89 d0                	mov    %edx,%eax
801033e5:	c1 e0 02             	shl    $0x2,%eax
801033e8:	01 d0                	add    %edx,%eax
801033ea:	01 c0                	add    %eax,%eax
801033ec:	89 c2                	mov    %eax,%edx
801033ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
801033f1:	83 e0 0f             	and    $0xf,%eax
801033f4:	01 d0                	add    %edx,%eax
801033f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801033f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801033fc:	c1 e8 04             	shr    $0x4,%eax
801033ff:	89 c2                	mov    %eax,%edx
80103401:	89 d0                	mov    %edx,%eax
80103403:	c1 e0 02             	shl    $0x2,%eax
80103406:	01 d0                	add    %edx,%eax
80103408:	01 c0                	add    %eax,%eax
8010340a:	89 c2                	mov    %eax,%edx
8010340c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010340f:	83 e0 0f             	and    $0xf,%eax
80103412:	01 d0                	add    %edx,%eax
80103414:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80103417:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010341a:	c1 e8 04             	shr    $0x4,%eax
8010341d:	89 c2                	mov    %eax,%edx
8010341f:	89 d0                	mov    %edx,%eax
80103421:	c1 e0 02             	shl    $0x2,%eax
80103424:	01 d0                	add    %edx,%eax
80103426:	01 c0                	add    %eax,%eax
80103428:	89 c2                	mov    %eax,%edx
8010342a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010342d:	83 e0 0f             	and    $0xf,%eax
80103430:	01 d0                	add    %edx,%eax
80103432:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103435:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103438:	c1 e8 04             	shr    $0x4,%eax
8010343b:	89 c2                	mov    %eax,%edx
8010343d:	89 d0                	mov    %edx,%eax
8010343f:	c1 e0 02             	shl    $0x2,%eax
80103442:	01 d0                	add    %edx,%eax
80103444:	01 c0                	add    %eax,%eax
80103446:	89 c2                	mov    %eax,%edx
80103448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010344b:	83 e0 0f             	and    $0xf,%eax
8010344e:	01 d0                	add    %edx,%eax
80103450:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103453:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103456:	c1 e8 04             	shr    $0x4,%eax
80103459:	89 c2                	mov    %eax,%edx
8010345b:	89 d0                	mov    %edx,%eax
8010345d:	c1 e0 02             	shl    $0x2,%eax
80103460:	01 d0                	add    %edx,%eax
80103462:	01 c0                	add    %eax,%eax
80103464:	89 c2                	mov    %eax,%edx
80103466:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103469:	83 e0 0f             	and    $0xf,%eax
8010346c:	01 d0                	add    %edx,%eax
8010346e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103471:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103474:	c1 e8 04             	shr    $0x4,%eax
80103477:	89 c2                	mov    %eax,%edx
80103479:	89 d0                	mov    %edx,%eax
8010347b:	c1 e0 02             	shl    $0x2,%eax
8010347e:	01 d0                	add    %edx,%eax
80103480:	01 c0                	add    %eax,%eax
80103482:	89 c2                	mov    %eax,%edx
80103484:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103487:	83 e0 0f             	and    $0xf,%eax
8010348a:	01 d0                	add    %edx,%eax
8010348c:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
8010348f:	8b 45 08             	mov    0x8(%ebp),%eax
80103492:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103495:	89 10                	mov    %edx,(%eax)
80103497:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010349a:	89 50 04             	mov    %edx,0x4(%eax)
8010349d:	8b 55 e0             	mov    -0x20(%ebp),%edx
801034a0:	89 50 08             	mov    %edx,0x8(%eax)
801034a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801034a6:	89 50 0c             	mov    %edx,0xc(%eax)
801034a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
801034ac:	89 50 10             	mov    %edx,0x10(%eax)
801034af:	8b 55 ec             	mov    -0x14(%ebp),%edx
801034b2:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801034b5:	8b 45 08             	mov    0x8(%ebp),%eax
801034b8:	8b 40 14             	mov    0x14(%eax),%eax
801034bb:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801034c1:	8b 45 08             	mov    0x8(%ebp),%eax
801034c4:	89 50 14             	mov    %edx,0x14(%eax)
}
801034c7:	90                   	nop
801034c8:	c9                   	leave  
801034c9:	c3                   	ret    

801034ca <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801034ca:	f3 0f 1e fb          	endbr32 
801034ce:	55                   	push   %ebp
801034cf:	89 e5                	mov    %esp,%ebp
801034d1:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801034d4:	83 ec 08             	sub    $0x8,%esp
801034d7:	68 99 9a 10 80       	push   $0x80109a99
801034dc:	68 20 57 11 80       	push   $0x80115720
801034e1:	e8 a0 20 00 00       	call   80105586 <initlock>
801034e6:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801034e9:	83 ec 08             	sub    $0x8,%esp
801034ec:	8d 45 dc             	lea    -0x24(%ebp),%eax
801034ef:	50                   	push   %eax
801034f0:	ff 75 08             	pushl  0x8(%ebp)
801034f3:	e8 f9 df ff ff       	call   801014f1 <readsb>
801034f8:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
801034fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034fe:	a3 54 57 11 80       	mov    %eax,0x80115754
  log.size = sb.nlog;
80103503:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103506:	a3 58 57 11 80       	mov    %eax,0x80115758
  log.dev = dev;
8010350b:	8b 45 08             	mov    0x8(%ebp),%eax
8010350e:	a3 64 57 11 80       	mov    %eax,0x80115764
  recover_from_log();
80103513:	e8 bf 01 00 00       	call   801036d7 <recover_from_log>
}
80103518:	90                   	nop
80103519:	c9                   	leave  
8010351a:	c3                   	ret    

8010351b <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
8010351b:	f3 0f 1e fb          	endbr32 
8010351f:	55                   	push   %ebp
80103520:	89 e5                	mov    %esp,%ebp
80103522:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103525:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010352c:	e9 95 00 00 00       	jmp    801035c6 <install_trans+0xab>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103531:	8b 15 54 57 11 80    	mov    0x80115754,%edx
80103537:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010353a:	01 d0                	add    %edx,%eax
8010353c:	83 c0 01             	add    $0x1,%eax
8010353f:	89 c2                	mov    %eax,%edx
80103541:	a1 64 57 11 80       	mov    0x80115764,%eax
80103546:	83 ec 08             	sub    $0x8,%esp
80103549:	52                   	push   %edx
8010354a:	50                   	push   %eax
8010354b:	e8 87 cc ff ff       	call   801001d7 <bread>
80103550:	83 c4 10             	add    $0x10,%esp
80103553:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103556:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103559:	83 c0 10             	add    $0x10,%eax
8010355c:	8b 04 85 2c 57 11 80 	mov    -0x7feea8d4(,%eax,4),%eax
80103563:	89 c2                	mov    %eax,%edx
80103565:	a1 64 57 11 80       	mov    0x80115764,%eax
8010356a:	83 ec 08             	sub    $0x8,%esp
8010356d:	52                   	push   %edx
8010356e:	50                   	push   %eax
8010356f:	e8 63 cc ff ff       	call   801001d7 <bread>
80103574:	83 c4 10             	add    $0x10,%esp
80103577:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010357a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010357d:	8d 50 5c             	lea    0x5c(%eax),%edx
80103580:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103583:	83 c0 5c             	add    $0x5c,%eax
80103586:	83 ec 04             	sub    $0x4,%esp
80103589:	68 00 02 00 00       	push   $0x200
8010358e:	52                   	push   %edx
8010358f:	50                   	push   %eax
80103590:	e8 7d 23 00 00       	call   80105912 <memmove>
80103595:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
80103598:	83 ec 0c             	sub    $0xc,%esp
8010359b:	ff 75 ec             	pushl  -0x14(%ebp)
8010359e:	e8 71 cc ff ff       	call   80100214 <bwrite>
801035a3:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
801035a6:	83 ec 0c             	sub    $0xc,%esp
801035a9:	ff 75 f0             	pushl  -0x10(%ebp)
801035ac:	e8 b0 cc ff ff       	call   80100261 <brelse>
801035b1:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801035b4:	83 ec 0c             	sub    $0xc,%esp
801035b7:	ff 75 ec             	pushl  -0x14(%ebp)
801035ba:	e8 a2 cc ff ff       	call   80100261 <brelse>
801035bf:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801035c2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801035c6:	a1 68 57 11 80       	mov    0x80115768,%eax
801035cb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801035ce:	0f 8c 5d ff ff ff    	jl     80103531 <install_trans+0x16>
  }
}
801035d4:	90                   	nop
801035d5:	90                   	nop
801035d6:	c9                   	leave  
801035d7:	c3                   	ret    

801035d8 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801035d8:	f3 0f 1e fb          	endbr32 
801035dc:	55                   	push   %ebp
801035dd:	89 e5                	mov    %esp,%ebp
801035df:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801035e2:	a1 54 57 11 80       	mov    0x80115754,%eax
801035e7:	89 c2                	mov    %eax,%edx
801035e9:	a1 64 57 11 80       	mov    0x80115764,%eax
801035ee:	83 ec 08             	sub    $0x8,%esp
801035f1:	52                   	push   %edx
801035f2:	50                   	push   %eax
801035f3:	e8 df cb ff ff       	call   801001d7 <bread>
801035f8:	83 c4 10             	add    $0x10,%esp
801035fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801035fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103601:	83 c0 5c             	add    $0x5c,%eax
80103604:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103607:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010360a:	8b 00                	mov    (%eax),%eax
8010360c:	a3 68 57 11 80       	mov    %eax,0x80115768
  for (i = 0; i < log.lh.n; i++) {
80103611:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103618:	eb 1b                	jmp    80103635 <read_head+0x5d>
    log.lh.block[i] = lh->block[i];
8010361a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010361d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103620:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103624:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103627:	83 c2 10             	add    $0x10,%edx
8010362a:	89 04 95 2c 57 11 80 	mov    %eax,-0x7feea8d4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103631:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103635:	a1 68 57 11 80       	mov    0x80115768,%eax
8010363a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010363d:	7c db                	jl     8010361a <read_head+0x42>
  }
  brelse(buf);
8010363f:	83 ec 0c             	sub    $0xc,%esp
80103642:	ff 75 f0             	pushl  -0x10(%ebp)
80103645:	e8 17 cc ff ff       	call   80100261 <brelse>
8010364a:	83 c4 10             	add    $0x10,%esp
}
8010364d:	90                   	nop
8010364e:	c9                   	leave  
8010364f:	c3                   	ret    

80103650 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103650:	f3 0f 1e fb          	endbr32 
80103654:	55                   	push   %ebp
80103655:	89 e5                	mov    %esp,%ebp
80103657:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010365a:	a1 54 57 11 80       	mov    0x80115754,%eax
8010365f:	89 c2                	mov    %eax,%edx
80103661:	a1 64 57 11 80       	mov    0x80115764,%eax
80103666:	83 ec 08             	sub    $0x8,%esp
80103669:	52                   	push   %edx
8010366a:	50                   	push   %eax
8010366b:	e8 67 cb ff ff       	call   801001d7 <bread>
80103670:	83 c4 10             	add    $0x10,%esp
80103673:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103676:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103679:	83 c0 5c             	add    $0x5c,%eax
8010367c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010367f:	8b 15 68 57 11 80    	mov    0x80115768,%edx
80103685:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103688:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010368a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103691:	eb 1b                	jmp    801036ae <write_head+0x5e>
    hb->block[i] = log.lh.block[i];
80103693:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103696:	83 c0 10             	add    $0x10,%eax
80103699:	8b 0c 85 2c 57 11 80 	mov    -0x7feea8d4(,%eax,4),%ecx
801036a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801036a6:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801036aa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801036ae:	a1 68 57 11 80       	mov    0x80115768,%eax
801036b3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801036b6:	7c db                	jl     80103693 <write_head+0x43>
  }
  bwrite(buf);
801036b8:	83 ec 0c             	sub    $0xc,%esp
801036bb:	ff 75 f0             	pushl  -0x10(%ebp)
801036be:	e8 51 cb ff ff       	call   80100214 <bwrite>
801036c3:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801036c6:	83 ec 0c             	sub    $0xc,%esp
801036c9:	ff 75 f0             	pushl  -0x10(%ebp)
801036cc:	e8 90 cb ff ff       	call   80100261 <brelse>
801036d1:	83 c4 10             	add    $0x10,%esp
}
801036d4:	90                   	nop
801036d5:	c9                   	leave  
801036d6:	c3                   	ret    

801036d7 <recover_from_log>:

static void
recover_from_log(void)
{
801036d7:	f3 0f 1e fb          	endbr32 
801036db:	55                   	push   %ebp
801036dc:	89 e5                	mov    %esp,%ebp
801036de:	83 ec 08             	sub    $0x8,%esp
  read_head();
801036e1:	e8 f2 fe ff ff       	call   801035d8 <read_head>
  install_trans(); // if committed, copy from log to disk
801036e6:	e8 30 fe ff ff       	call   8010351b <install_trans>
  log.lh.n = 0;
801036eb:	c7 05 68 57 11 80 00 	movl   $0x0,0x80115768
801036f2:	00 00 00 
  write_head(); // clear the log
801036f5:	e8 56 ff ff ff       	call   80103650 <write_head>
}
801036fa:	90                   	nop
801036fb:	c9                   	leave  
801036fc:	c3                   	ret    

801036fd <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801036fd:	f3 0f 1e fb          	endbr32 
80103701:	55                   	push   %ebp
80103702:	89 e5                	mov    %esp,%ebp
80103704:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103707:	83 ec 0c             	sub    $0xc,%esp
8010370a:	68 20 57 11 80       	push   $0x80115720
8010370f:	e8 98 1e 00 00       	call   801055ac <acquire>
80103714:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103717:	a1 60 57 11 80       	mov    0x80115760,%eax
8010371c:	85 c0                	test   %eax,%eax
8010371e:	74 17                	je     80103737 <begin_op+0x3a>
      sleep(&log, &log.lock);
80103720:	83 ec 08             	sub    $0x8,%esp
80103723:	68 20 57 11 80       	push   $0x80115720
80103728:	68 20 57 11 80       	push   $0x80115720
8010372d:	e8 08 1a 00 00       	call   8010513a <sleep>
80103732:	83 c4 10             	add    $0x10,%esp
80103735:	eb e0                	jmp    80103717 <begin_op+0x1a>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103737:	8b 0d 68 57 11 80    	mov    0x80115768,%ecx
8010373d:	a1 5c 57 11 80       	mov    0x8011575c,%eax
80103742:	8d 50 01             	lea    0x1(%eax),%edx
80103745:	89 d0                	mov    %edx,%eax
80103747:	c1 e0 02             	shl    $0x2,%eax
8010374a:	01 d0                	add    %edx,%eax
8010374c:	01 c0                	add    %eax,%eax
8010374e:	01 c8                	add    %ecx,%eax
80103750:	83 f8 1e             	cmp    $0x1e,%eax
80103753:	7e 17                	jle    8010376c <begin_op+0x6f>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103755:	83 ec 08             	sub    $0x8,%esp
80103758:	68 20 57 11 80       	push   $0x80115720
8010375d:	68 20 57 11 80       	push   $0x80115720
80103762:	e8 d3 19 00 00       	call   8010513a <sleep>
80103767:	83 c4 10             	add    $0x10,%esp
8010376a:	eb ab                	jmp    80103717 <begin_op+0x1a>
    } else {
      log.outstanding += 1;
8010376c:	a1 5c 57 11 80       	mov    0x8011575c,%eax
80103771:	83 c0 01             	add    $0x1,%eax
80103774:	a3 5c 57 11 80       	mov    %eax,0x8011575c
      release(&log.lock);
80103779:	83 ec 0c             	sub    $0xc,%esp
8010377c:	68 20 57 11 80       	push   $0x80115720
80103781:	e8 98 1e 00 00       	call   8010561e <release>
80103786:	83 c4 10             	add    $0x10,%esp
      break;
80103789:	90                   	nop
    }
  }
}
8010378a:	90                   	nop
8010378b:	c9                   	leave  
8010378c:	c3                   	ret    

8010378d <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010378d:	f3 0f 1e fb          	endbr32 
80103791:	55                   	push   %ebp
80103792:	89 e5                	mov    %esp,%ebp
80103794:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103797:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
8010379e:	83 ec 0c             	sub    $0xc,%esp
801037a1:	68 20 57 11 80       	push   $0x80115720
801037a6:	e8 01 1e 00 00       	call   801055ac <acquire>
801037ab:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801037ae:	a1 5c 57 11 80       	mov    0x8011575c,%eax
801037b3:	83 e8 01             	sub    $0x1,%eax
801037b6:	a3 5c 57 11 80       	mov    %eax,0x8011575c
  if(log.committing)
801037bb:	a1 60 57 11 80       	mov    0x80115760,%eax
801037c0:	85 c0                	test   %eax,%eax
801037c2:	74 0d                	je     801037d1 <end_op+0x44>
    panic("log.committing");
801037c4:	83 ec 0c             	sub    $0xc,%esp
801037c7:	68 9d 9a 10 80       	push   $0x80109a9d
801037cc:	e8 37 ce ff ff       	call   80100608 <panic>
  if(log.outstanding == 0){
801037d1:	a1 5c 57 11 80       	mov    0x8011575c,%eax
801037d6:	85 c0                	test   %eax,%eax
801037d8:	75 13                	jne    801037ed <end_op+0x60>
    do_commit = 1;
801037da:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801037e1:	c7 05 60 57 11 80 01 	movl   $0x1,0x80115760
801037e8:	00 00 00 
801037eb:	eb 10                	jmp    801037fd <end_op+0x70>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
801037ed:	83 ec 0c             	sub    $0xc,%esp
801037f0:	68 20 57 11 80       	push   $0x80115720
801037f5:	e8 32 1a 00 00       	call   8010522c <wakeup>
801037fa:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801037fd:	83 ec 0c             	sub    $0xc,%esp
80103800:	68 20 57 11 80       	push   $0x80115720
80103805:	e8 14 1e 00 00       	call   8010561e <release>
8010380a:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
8010380d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103811:	74 3f                	je     80103852 <end_op+0xc5>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103813:	e8 fa 00 00 00       	call   80103912 <commit>
    acquire(&log.lock);
80103818:	83 ec 0c             	sub    $0xc,%esp
8010381b:	68 20 57 11 80       	push   $0x80115720
80103820:	e8 87 1d 00 00       	call   801055ac <acquire>
80103825:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103828:	c7 05 60 57 11 80 00 	movl   $0x0,0x80115760
8010382f:	00 00 00 
    wakeup(&log);
80103832:	83 ec 0c             	sub    $0xc,%esp
80103835:	68 20 57 11 80       	push   $0x80115720
8010383a:	e8 ed 19 00 00       	call   8010522c <wakeup>
8010383f:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103842:	83 ec 0c             	sub    $0xc,%esp
80103845:	68 20 57 11 80       	push   $0x80115720
8010384a:	e8 cf 1d 00 00       	call   8010561e <release>
8010384f:	83 c4 10             	add    $0x10,%esp
  }
}
80103852:	90                   	nop
80103853:	c9                   	leave  
80103854:	c3                   	ret    

80103855 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
80103855:	f3 0f 1e fb          	endbr32 
80103859:	55                   	push   %ebp
8010385a:	89 e5                	mov    %esp,%ebp
8010385c:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010385f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103866:	e9 95 00 00 00       	jmp    80103900 <write_log+0xab>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010386b:	8b 15 54 57 11 80    	mov    0x80115754,%edx
80103871:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103874:	01 d0                	add    %edx,%eax
80103876:	83 c0 01             	add    $0x1,%eax
80103879:	89 c2                	mov    %eax,%edx
8010387b:	a1 64 57 11 80       	mov    0x80115764,%eax
80103880:	83 ec 08             	sub    $0x8,%esp
80103883:	52                   	push   %edx
80103884:	50                   	push   %eax
80103885:	e8 4d c9 ff ff       	call   801001d7 <bread>
8010388a:	83 c4 10             	add    $0x10,%esp
8010388d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103890:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103893:	83 c0 10             	add    $0x10,%eax
80103896:	8b 04 85 2c 57 11 80 	mov    -0x7feea8d4(,%eax,4),%eax
8010389d:	89 c2                	mov    %eax,%edx
8010389f:	a1 64 57 11 80       	mov    0x80115764,%eax
801038a4:	83 ec 08             	sub    $0x8,%esp
801038a7:	52                   	push   %edx
801038a8:	50                   	push   %eax
801038a9:	e8 29 c9 ff ff       	call   801001d7 <bread>
801038ae:	83 c4 10             	add    $0x10,%esp
801038b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801038b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801038b7:	8d 50 5c             	lea    0x5c(%eax),%edx
801038ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038bd:	83 c0 5c             	add    $0x5c,%eax
801038c0:	83 ec 04             	sub    $0x4,%esp
801038c3:	68 00 02 00 00       	push   $0x200
801038c8:	52                   	push   %edx
801038c9:	50                   	push   %eax
801038ca:	e8 43 20 00 00       	call   80105912 <memmove>
801038cf:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801038d2:	83 ec 0c             	sub    $0xc,%esp
801038d5:	ff 75 f0             	pushl  -0x10(%ebp)
801038d8:	e8 37 c9 ff ff       	call   80100214 <bwrite>
801038dd:	83 c4 10             	add    $0x10,%esp
    brelse(from);
801038e0:	83 ec 0c             	sub    $0xc,%esp
801038e3:	ff 75 ec             	pushl  -0x14(%ebp)
801038e6:	e8 76 c9 ff ff       	call   80100261 <brelse>
801038eb:	83 c4 10             	add    $0x10,%esp
    brelse(to);
801038ee:	83 ec 0c             	sub    $0xc,%esp
801038f1:	ff 75 f0             	pushl  -0x10(%ebp)
801038f4:	e8 68 c9 ff ff       	call   80100261 <brelse>
801038f9:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801038fc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103900:	a1 68 57 11 80       	mov    0x80115768,%eax
80103905:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103908:	0f 8c 5d ff ff ff    	jl     8010386b <write_log+0x16>
  }
}
8010390e:	90                   	nop
8010390f:	90                   	nop
80103910:	c9                   	leave  
80103911:	c3                   	ret    

80103912 <commit>:

static void
commit()
{
80103912:	f3 0f 1e fb          	endbr32 
80103916:	55                   	push   %ebp
80103917:	89 e5                	mov    %esp,%ebp
80103919:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
8010391c:	a1 68 57 11 80       	mov    0x80115768,%eax
80103921:	85 c0                	test   %eax,%eax
80103923:	7e 1e                	jle    80103943 <commit+0x31>
    write_log();     // Write modified blocks from cache to log
80103925:	e8 2b ff ff ff       	call   80103855 <write_log>
    write_head();    // Write header to disk -- the real commit
8010392a:	e8 21 fd ff ff       	call   80103650 <write_head>
    install_trans(); // Now install writes to home locations
8010392f:	e8 e7 fb ff ff       	call   8010351b <install_trans>
    log.lh.n = 0;
80103934:	c7 05 68 57 11 80 00 	movl   $0x0,0x80115768
8010393b:	00 00 00 
    write_head();    // Erase the transaction from the log
8010393e:	e8 0d fd ff ff       	call   80103650 <write_head>
  }
}
80103943:	90                   	nop
80103944:	c9                   	leave  
80103945:	c3                   	ret    

80103946 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103946:	f3 0f 1e fb          	endbr32 
8010394a:	55                   	push   %ebp
8010394b:	89 e5                	mov    %esp,%ebp
8010394d:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103950:	a1 68 57 11 80       	mov    0x80115768,%eax
80103955:	83 f8 1d             	cmp    $0x1d,%eax
80103958:	7f 12                	jg     8010396c <log_write+0x26>
8010395a:	a1 68 57 11 80       	mov    0x80115768,%eax
8010395f:	8b 15 58 57 11 80    	mov    0x80115758,%edx
80103965:	83 ea 01             	sub    $0x1,%edx
80103968:	39 d0                	cmp    %edx,%eax
8010396a:	7c 0d                	jl     80103979 <log_write+0x33>
    panic("too big a transaction");
8010396c:	83 ec 0c             	sub    $0xc,%esp
8010396f:	68 ac 9a 10 80       	push   $0x80109aac
80103974:	e8 8f cc ff ff       	call   80100608 <panic>
  if (log.outstanding < 1)
80103979:	a1 5c 57 11 80       	mov    0x8011575c,%eax
8010397e:	85 c0                	test   %eax,%eax
80103980:	7f 0d                	jg     8010398f <log_write+0x49>
    panic("log_write outside of trans");
80103982:	83 ec 0c             	sub    $0xc,%esp
80103985:	68 c2 9a 10 80       	push   $0x80109ac2
8010398a:	e8 79 cc ff ff       	call   80100608 <panic>

  acquire(&log.lock);
8010398f:	83 ec 0c             	sub    $0xc,%esp
80103992:	68 20 57 11 80       	push   $0x80115720
80103997:	e8 10 1c 00 00       	call   801055ac <acquire>
8010399c:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
8010399f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801039a6:	eb 1d                	jmp    801039c5 <log_write+0x7f>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801039a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039ab:	83 c0 10             	add    $0x10,%eax
801039ae:	8b 04 85 2c 57 11 80 	mov    -0x7feea8d4(,%eax,4),%eax
801039b5:	89 c2                	mov    %eax,%edx
801039b7:	8b 45 08             	mov    0x8(%ebp),%eax
801039ba:	8b 40 08             	mov    0x8(%eax),%eax
801039bd:	39 c2                	cmp    %eax,%edx
801039bf:	74 10                	je     801039d1 <log_write+0x8b>
  for (i = 0; i < log.lh.n; i++) {
801039c1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801039c5:	a1 68 57 11 80       	mov    0x80115768,%eax
801039ca:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801039cd:	7c d9                	jl     801039a8 <log_write+0x62>
801039cf:	eb 01                	jmp    801039d2 <log_write+0x8c>
      break;
801039d1:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
801039d2:	8b 45 08             	mov    0x8(%ebp),%eax
801039d5:	8b 40 08             	mov    0x8(%eax),%eax
801039d8:	89 c2                	mov    %eax,%edx
801039da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039dd:	83 c0 10             	add    $0x10,%eax
801039e0:	89 14 85 2c 57 11 80 	mov    %edx,-0x7feea8d4(,%eax,4)
  if (i == log.lh.n)
801039e7:	a1 68 57 11 80       	mov    0x80115768,%eax
801039ec:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801039ef:	75 0d                	jne    801039fe <log_write+0xb8>
    log.lh.n++;
801039f1:	a1 68 57 11 80       	mov    0x80115768,%eax
801039f6:	83 c0 01             	add    $0x1,%eax
801039f9:	a3 68 57 11 80       	mov    %eax,0x80115768
  b->flags |= B_DIRTY; // prevent eviction
801039fe:	8b 45 08             	mov    0x8(%ebp),%eax
80103a01:	8b 00                	mov    (%eax),%eax
80103a03:	83 c8 04             	or     $0x4,%eax
80103a06:	89 c2                	mov    %eax,%edx
80103a08:	8b 45 08             	mov    0x8(%ebp),%eax
80103a0b:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103a0d:	83 ec 0c             	sub    $0xc,%esp
80103a10:	68 20 57 11 80       	push   $0x80115720
80103a15:	e8 04 1c 00 00       	call   8010561e <release>
80103a1a:	83 c4 10             	add    $0x10,%esp
}
80103a1d:	90                   	nop
80103a1e:	c9                   	leave  
80103a1f:	c3                   	ret    

80103a20 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103a26:	8b 55 08             	mov    0x8(%ebp),%edx
80103a29:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103a2f:	f0 87 02             	lock xchg %eax,(%edx)
80103a32:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103a35:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103a38:	c9                   	leave  
80103a39:	c3                   	ret    

80103a3a <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103a3a:	f3 0f 1e fb          	endbr32 
80103a3e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103a42:	83 e4 f0             	and    $0xfffffff0,%esp
80103a45:	ff 71 fc             	pushl  -0x4(%ecx)
80103a48:	55                   	push   %ebp
80103a49:	89 e5                	mov    %esp,%ebp
80103a4b:	51                   	push   %ecx
80103a4c:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103a4f:	83 ec 08             	sub    $0x8,%esp
80103a52:	68 00 00 40 80       	push   $0x80400000
80103a57:	68 48 9f 11 80       	push   $0x80119f48
80103a5c:	e8 78 f2 ff ff       	call   80102cd9 <kinit1>
80103a61:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103a64:	e8 bb 49 00 00       	call   80108424 <kvmalloc>
  mpinit();        // detect other processors
80103a69:	e8 d9 03 00 00       	call   80103e47 <mpinit>
  lapicinit();     // interrupt controller
80103a6e:	e8 f5 f5 ff ff       	call   80103068 <lapicinit>
  seginit();       // segment descriptors
80103a73:	e8 64 44 00 00       	call   80107edc <seginit>
  picinit();       // disable pic
80103a78:	e8 35 05 00 00       	call   80103fb2 <picinit>
  ioapicinit();    // another interrupt controller
80103a7d:	e8 6a f1 ff ff       	call   80102bec <ioapicinit>
  consoleinit();   // console hardware
80103a82:	e8 5a d1 ff ff       	call   80100be1 <consoleinit>
  uartinit();      // serial port
80103a87:	e8 d9 37 00 00       	call   80107265 <uartinit>
  pinit();         // process table
80103a8c:	e8 08 0a 00 00       	call   80104499 <pinit>
  tvinit();        // trap vectors
80103a91:	e8 71 33 00 00       	call   80106e07 <tvinit>
  binit();         // buffer cache
80103a96:	e8 99 c5 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103a9b:	e8 26 d6 ff ff       	call   801010c6 <fileinit>
  ideinit();       // disk 
80103aa0:	e8 06 ed ff ff       	call   801027ab <ideinit>
  startothers();   // start other processors
80103aa5:	e8 88 00 00 00       	call   80103b32 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103aaa:	83 ec 08             	sub    $0x8,%esp
80103aad:	68 00 00 00 8e       	push   $0x8e000000
80103ab2:	68 00 00 40 80       	push   $0x80400000
80103ab7:	e8 5a f2 ff ff       	call   80102d16 <kinit2>
80103abc:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103abf:	e8 db 0b 00 00       	call   8010469f <userinit>
  mpmain();        // finish this processor's setup
80103ac4:	e8 1e 00 00 00       	call   80103ae7 <mpmain>

80103ac9 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103ac9:	f3 0f 1e fb          	endbr32 
80103acd:	55                   	push   %ebp
80103ace:	89 e5                	mov    %esp,%ebp
80103ad0:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103ad3:	e8 68 49 00 00       	call   80108440 <switchkvm>
  seginit();
80103ad8:	e8 ff 43 00 00       	call   80107edc <seginit>
  lapicinit();
80103add:	e8 86 f5 ff ff       	call   80103068 <lapicinit>
  mpmain();
80103ae2:	e8 00 00 00 00       	call   80103ae7 <mpmain>

80103ae7 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103ae7:	f3 0f 1e fb          	endbr32 
80103aeb:	55                   	push   %ebp
80103aec:	89 e5                	mov    %esp,%ebp
80103aee:	53                   	push   %ebx
80103aef:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103af2:	e8 c4 09 00 00       	call   801044bb <cpuid>
80103af7:	89 c3                	mov    %eax,%ebx
80103af9:	e8 bd 09 00 00       	call   801044bb <cpuid>
80103afe:	83 ec 04             	sub    $0x4,%esp
80103b01:	53                   	push   %ebx
80103b02:	50                   	push   %eax
80103b03:	68 dd 9a 10 80       	push   $0x80109add
80103b08:	e8 0b c9 ff ff       	call   80100418 <cprintf>
80103b0d:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103b10:	e8 6c 34 00 00       	call   80106f81 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103b15:	e8 c0 09 00 00       	call   801044da <mycpu>
80103b1a:	05 a0 00 00 00       	add    $0xa0,%eax
80103b1f:	83 ec 08             	sub    $0x8,%esp
80103b22:	6a 01                	push   $0x1
80103b24:	50                   	push   %eax
80103b25:	e8 f6 fe ff ff       	call   80103a20 <xchg>
80103b2a:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103b2d:	e8 04 14 00 00       	call   80104f36 <scheduler>

80103b32 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103b32:	f3 0f 1e fb          	endbr32 
80103b36:	55                   	push   %ebp
80103b37:	89 e5                	mov    %esp,%ebp
80103b39:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
80103b3c:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103b43:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103b48:	83 ec 04             	sub    $0x4,%esp
80103b4b:	50                   	push   %eax
80103b4c:	68 0c d5 10 80       	push   $0x8010d50c
80103b51:	ff 75 f0             	pushl  -0x10(%ebp)
80103b54:	e8 b9 1d 00 00       	call   80105912 <memmove>
80103b59:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103b5c:	c7 45 f4 20 58 11 80 	movl   $0x80115820,-0xc(%ebp)
80103b63:	eb 79                	jmp    80103bde <startothers+0xac>
    if(c == mycpu())  // We've started already.
80103b65:	e8 70 09 00 00       	call   801044da <mycpu>
80103b6a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103b6d:	74 67                	je     80103bd6 <startothers+0xa4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103b6f:	e8 aa f2 ff ff       	call   80102e1e <kalloc>
80103b74:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103b77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b7a:	83 e8 04             	sub    $0x4,%eax
80103b7d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103b80:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103b86:	89 10                	mov    %edx,(%eax)
    *(void(**)(void))(code-8) = mpenter;
80103b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b8b:	83 e8 08             	sub    $0x8,%eax
80103b8e:	c7 00 c9 3a 10 80    	movl   $0x80103ac9,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103b94:	b8 00 c0 10 80       	mov    $0x8010c000,%eax
80103b99:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ba2:	83 e8 0c             	sub    $0xc,%eax
80103ba5:	89 10                	mov    %edx,(%eax)

    lapicstartap(c->apicid, V2P(code));
80103ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103baa:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bb3:	0f b6 00             	movzbl (%eax),%eax
80103bb6:	0f b6 c0             	movzbl %al,%eax
80103bb9:	83 ec 08             	sub    $0x8,%esp
80103bbc:	52                   	push   %edx
80103bbd:	50                   	push   %eax
80103bbe:	e8 17 f6 ff ff       	call   801031da <lapicstartap>
80103bc3:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103bc6:	90                   	nop
80103bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bca:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
80103bd0:	85 c0                	test   %eax,%eax
80103bd2:	74 f3                	je     80103bc7 <startothers+0x95>
80103bd4:	eb 01                	jmp    80103bd7 <startothers+0xa5>
      continue;
80103bd6:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
80103bd7:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
80103bde:	a1 a0 5d 11 80       	mov    0x80115da0,%eax
80103be3:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103be9:	05 20 58 11 80       	add    $0x80115820,%eax
80103bee:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103bf1:	0f 82 6e ff ff ff    	jb     80103b65 <startothers+0x33>
      ;
  }
}
80103bf7:	90                   	nop
80103bf8:	90                   	nop
80103bf9:	c9                   	leave  
80103bfa:	c3                   	ret    

80103bfb <inb>:
{
80103bfb:	55                   	push   %ebp
80103bfc:	89 e5                	mov    %esp,%ebp
80103bfe:	83 ec 14             	sub    $0x14,%esp
80103c01:	8b 45 08             	mov    0x8(%ebp),%eax
80103c04:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103c08:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103c0c:	89 c2                	mov    %eax,%edx
80103c0e:	ec                   	in     (%dx),%al
80103c0f:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103c12:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103c16:	c9                   	leave  
80103c17:	c3                   	ret    

80103c18 <outb>:
{
80103c18:	55                   	push   %ebp
80103c19:	89 e5                	mov    %esp,%ebp
80103c1b:	83 ec 08             	sub    $0x8,%esp
80103c1e:	8b 45 08             	mov    0x8(%ebp),%eax
80103c21:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c24:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103c28:	89 d0                	mov    %edx,%eax
80103c2a:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103c2d:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103c31:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103c35:	ee                   	out    %al,(%dx)
}
80103c36:	90                   	nop
80103c37:	c9                   	leave  
80103c38:	c3                   	ret    

80103c39 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80103c39:	f3 0f 1e fb          	endbr32 
80103c3d:	55                   	push   %ebp
80103c3e:	89 e5                	mov    %esp,%ebp
80103c40:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
80103c43:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103c4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103c51:	eb 15                	jmp    80103c68 <sum+0x2f>
    sum += addr[i];
80103c53:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103c56:	8b 45 08             	mov    0x8(%ebp),%eax
80103c59:	01 d0                	add    %edx,%eax
80103c5b:	0f b6 00             	movzbl (%eax),%eax
80103c5e:	0f b6 c0             	movzbl %al,%eax
80103c61:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
80103c64:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103c68:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103c6b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103c6e:	7c e3                	jl     80103c53 <sum+0x1a>
  return sum;
80103c70:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103c73:	c9                   	leave  
80103c74:	c3                   	ret    

80103c75 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103c75:	f3 0f 1e fb          	endbr32 
80103c79:	55                   	push   %ebp
80103c7a:	89 e5                	mov    %esp,%ebp
80103c7c:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103c7f:	8b 45 08             	mov    0x8(%ebp),%eax
80103c82:	05 00 00 00 80       	add    $0x80000000,%eax
80103c87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103c8a:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c90:	01 d0                	add    %edx,%eax
80103c92:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c98:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c9b:	eb 36                	jmp    80103cd3 <mpsearch1+0x5e>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103c9d:	83 ec 04             	sub    $0x4,%esp
80103ca0:	6a 04                	push   $0x4
80103ca2:	68 f4 9a 10 80       	push   $0x80109af4
80103ca7:	ff 75 f4             	pushl  -0xc(%ebp)
80103caa:	e8 07 1c 00 00       	call   801058b6 <memcmp>
80103caf:	83 c4 10             	add    $0x10,%esp
80103cb2:	85 c0                	test   %eax,%eax
80103cb4:	75 19                	jne    80103ccf <mpsearch1+0x5a>
80103cb6:	83 ec 08             	sub    $0x8,%esp
80103cb9:	6a 10                	push   $0x10
80103cbb:	ff 75 f4             	pushl  -0xc(%ebp)
80103cbe:	e8 76 ff ff ff       	call   80103c39 <sum>
80103cc3:	83 c4 10             	add    $0x10,%esp
80103cc6:	84 c0                	test   %al,%al
80103cc8:	75 05                	jne    80103ccf <mpsearch1+0x5a>
      return (struct mp*)p;
80103cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ccd:	eb 11                	jmp    80103ce0 <mpsearch1+0x6b>
  for(p = addr; p < e; p += sizeof(struct mp))
80103ccf:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cd6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103cd9:	72 c2                	jb     80103c9d <mpsearch1+0x28>
  return 0;
80103cdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103ce0:	c9                   	leave  
80103ce1:	c3                   	ret    

80103ce2 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103ce2:	f3 0f 1e fb          	endbr32 
80103ce6:	55                   	push   %ebp
80103ce7:	89 e5                	mov    %esp,%ebp
80103ce9:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103cec:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cf6:	83 c0 0f             	add    $0xf,%eax
80103cf9:	0f b6 00             	movzbl (%eax),%eax
80103cfc:	0f b6 c0             	movzbl %al,%eax
80103cff:	c1 e0 08             	shl    $0x8,%eax
80103d02:	89 c2                	mov    %eax,%edx
80103d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d07:	83 c0 0e             	add    $0xe,%eax
80103d0a:	0f b6 00             	movzbl (%eax),%eax
80103d0d:	0f b6 c0             	movzbl %al,%eax
80103d10:	09 d0                	or     %edx,%eax
80103d12:	c1 e0 04             	shl    $0x4,%eax
80103d15:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103d18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103d1c:	74 21                	je     80103d3f <mpsearch+0x5d>
    if((mp = mpsearch1(p, 1024)))
80103d1e:	83 ec 08             	sub    $0x8,%esp
80103d21:	68 00 04 00 00       	push   $0x400
80103d26:	ff 75 f0             	pushl  -0x10(%ebp)
80103d29:	e8 47 ff ff ff       	call   80103c75 <mpsearch1>
80103d2e:	83 c4 10             	add    $0x10,%esp
80103d31:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d34:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103d38:	74 51                	je     80103d8b <mpsearch+0xa9>
      return mp;
80103d3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d3d:	eb 61                	jmp    80103da0 <mpsearch+0xbe>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d42:	83 c0 14             	add    $0x14,%eax
80103d45:	0f b6 00             	movzbl (%eax),%eax
80103d48:	0f b6 c0             	movzbl %al,%eax
80103d4b:	c1 e0 08             	shl    $0x8,%eax
80103d4e:	89 c2                	mov    %eax,%edx
80103d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d53:	83 c0 13             	add    $0x13,%eax
80103d56:	0f b6 00             	movzbl (%eax),%eax
80103d59:	0f b6 c0             	movzbl %al,%eax
80103d5c:	09 d0                	or     %edx,%eax
80103d5e:	c1 e0 0a             	shl    $0xa,%eax
80103d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d67:	2d 00 04 00 00       	sub    $0x400,%eax
80103d6c:	83 ec 08             	sub    $0x8,%esp
80103d6f:	68 00 04 00 00       	push   $0x400
80103d74:	50                   	push   %eax
80103d75:	e8 fb fe ff ff       	call   80103c75 <mpsearch1>
80103d7a:	83 c4 10             	add    $0x10,%esp
80103d7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d80:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103d84:	74 05                	je     80103d8b <mpsearch+0xa9>
      return mp;
80103d86:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d89:	eb 15                	jmp    80103da0 <mpsearch+0xbe>
  }
  return mpsearch1(0xF0000, 0x10000);
80103d8b:	83 ec 08             	sub    $0x8,%esp
80103d8e:	68 00 00 01 00       	push   $0x10000
80103d93:	68 00 00 0f 00       	push   $0xf0000
80103d98:	e8 d8 fe ff ff       	call   80103c75 <mpsearch1>
80103d9d:	83 c4 10             	add    $0x10,%esp
}
80103da0:	c9                   	leave  
80103da1:	c3                   	ret    

80103da2 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103da2:	f3 0f 1e fb          	endbr32 
80103da6:	55                   	push   %ebp
80103da7:	89 e5                	mov    %esp,%ebp
80103da9:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103dac:	e8 31 ff ff ff       	call   80103ce2 <mpsearch>
80103db1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103db4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103db8:	74 0a                	je     80103dc4 <mpconfig+0x22>
80103dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dbd:	8b 40 04             	mov    0x4(%eax),%eax
80103dc0:	85 c0                	test   %eax,%eax
80103dc2:	75 07                	jne    80103dcb <mpconfig+0x29>
    return 0;
80103dc4:	b8 00 00 00 00       	mov    $0x0,%eax
80103dc9:	eb 7a                	jmp    80103e45 <mpconfig+0xa3>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dce:	8b 40 04             	mov    0x4(%eax),%eax
80103dd1:	05 00 00 00 80       	add    $0x80000000,%eax
80103dd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103dd9:	83 ec 04             	sub    $0x4,%esp
80103ddc:	6a 04                	push   $0x4
80103dde:	68 f9 9a 10 80       	push   $0x80109af9
80103de3:	ff 75 f0             	pushl  -0x10(%ebp)
80103de6:	e8 cb 1a 00 00       	call   801058b6 <memcmp>
80103deb:	83 c4 10             	add    $0x10,%esp
80103dee:	85 c0                	test   %eax,%eax
80103df0:	74 07                	je     80103df9 <mpconfig+0x57>
    return 0;
80103df2:	b8 00 00 00 00       	mov    $0x0,%eax
80103df7:	eb 4c                	jmp    80103e45 <mpconfig+0xa3>
  if(conf->version != 1 && conf->version != 4)
80103df9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103dfc:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103e00:	3c 01                	cmp    $0x1,%al
80103e02:	74 12                	je     80103e16 <mpconfig+0x74>
80103e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e07:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103e0b:	3c 04                	cmp    $0x4,%al
80103e0d:	74 07                	je     80103e16 <mpconfig+0x74>
    return 0;
80103e0f:	b8 00 00 00 00       	mov    $0x0,%eax
80103e14:	eb 2f                	jmp    80103e45 <mpconfig+0xa3>
  if(sum((uchar*)conf, conf->length) != 0)
80103e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e19:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103e1d:	0f b7 c0             	movzwl %ax,%eax
80103e20:	83 ec 08             	sub    $0x8,%esp
80103e23:	50                   	push   %eax
80103e24:	ff 75 f0             	pushl  -0x10(%ebp)
80103e27:	e8 0d fe ff ff       	call   80103c39 <sum>
80103e2c:	83 c4 10             	add    $0x10,%esp
80103e2f:	84 c0                	test   %al,%al
80103e31:	74 07                	je     80103e3a <mpconfig+0x98>
    return 0;
80103e33:	b8 00 00 00 00       	mov    $0x0,%eax
80103e38:	eb 0b                	jmp    80103e45 <mpconfig+0xa3>
  *pmp = mp;
80103e3a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e40:	89 10                	mov    %edx,(%eax)
  return conf;
80103e42:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103e45:	c9                   	leave  
80103e46:	c3                   	ret    

80103e47 <mpinit>:

void
mpinit(void)
{
80103e47:	f3 0f 1e fb          	endbr32 
80103e4b:	55                   	push   %ebp
80103e4c:	89 e5                	mov    %esp,%ebp
80103e4e:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103e51:	83 ec 0c             	sub    $0xc,%esp
80103e54:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103e57:	50                   	push   %eax
80103e58:	e8 45 ff ff ff       	call   80103da2 <mpconfig>
80103e5d:	83 c4 10             	add    $0x10,%esp
80103e60:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103e63:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103e67:	75 0d                	jne    80103e76 <mpinit+0x2f>
    panic("Expect to run on an SMP");
80103e69:	83 ec 0c             	sub    $0xc,%esp
80103e6c:	68 fe 9a 10 80       	push   $0x80109afe
80103e71:	e8 92 c7 ff ff       	call   80100608 <panic>
  ismp = 1;
80103e76:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103e7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103e80:	8b 40 24             	mov    0x24(%eax),%eax
80103e83:	a3 1c 57 11 80       	mov    %eax,0x8011571c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103e88:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103e8b:	83 c0 2c             	add    $0x2c,%eax
80103e8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e91:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103e94:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103e98:	0f b7 d0             	movzwl %ax,%edx
80103e9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103e9e:	01 d0                	add    %edx,%eax
80103ea0:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103ea3:	e9 8c 00 00 00       	jmp    80103f34 <mpinit+0xed>
    switch(*p){
80103ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103eab:	0f b6 00             	movzbl (%eax),%eax
80103eae:	0f b6 c0             	movzbl %al,%eax
80103eb1:	83 f8 04             	cmp    $0x4,%eax
80103eb4:	7f 76                	jg     80103f2c <mpinit+0xe5>
80103eb6:	83 f8 03             	cmp    $0x3,%eax
80103eb9:	7d 6b                	jge    80103f26 <mpinit+0xdf>
80103ebb:	83 f8 02             	cmp    $0x2,%eax
80103ebe:	74 4e                	je     80103f0e <mpinit+0xc7>
80103ec0:	83 f8 02             	cmp    $0x2,%eax
80103ec3:	7f 67                	jg     80103f2c <mpinit+0xe5>
80103ec5:	85 c0                	test   %eax,%eax
80103ec7:	74 07                	je     80103ed0 <mpinit+0x89>
80103ec9:	83 f8 01             	cmp    $0x1,%eax
80103ecc:	74 58                	je     80103f26 <mpinit+0xdf>
80103ece:	eb 5c                	jmp    80103f2c <mpinit+0xe5>
    case MPPROC:
      proc = (struct mpproc*)p;
80103ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ed3:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if(ncpu < NCPU) {
80103ed6:	a1 a0 5d 11 80       	mov    0x80115da0,%eax
80103edb:	83 f8 07             	cmp    $0x7,%eax
80103ede:	7f 28                	jg     80103f08 <mpinit+0xc1>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103ee0:	8b 15 a0 5d 11 80    	mov    0x80115da0,%edx
80103ee6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103ee9:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103eed:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80103ef3:	81 c2 20 58 11 80    	add    $0x80115820,%edx
80103ef9:	88 02                	mov    %al,(%edx)
        ncpu++;
80103efb:	a1 a0 5d 11 80       	mov    0x80115da0,%eax
80103f00:	83 c0 01             	add    $0x1,%eax
80103f03:	a3 a0 5d 11 80       	mov    %eax,0x80115da0
      }
      p += sizeof(struct mpproc);
80103f08:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103f0c:	eb 26                	jmp    80103f34 <mpinit+0xed>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103f14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103f17:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103f1b:	a2 00 58 11 80       	mov    %al,0x80115800
      p += sizeof(struct mpioapic);
80103f20:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103f24:	eb 0e                	jmp    80103f34 <mpinit+0xed>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103f26:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103f2a:	eb 08                	jmp    80103f34 <mpinit+0xed>
    default:
      ismp = 0;
80103f2c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
80103f33:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f37:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80103f3a:	0f 82 68 ff ff ff    	jb     80103ea8 <mpinit+0x61>
    }
  }
  if(!ismp)
80103f40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103f44:	75 0d                	jne    80103f53 <mpinit+0x10c>
    panic("Didn't find a suitable machine");
80103f46:	83 ec 0c             	sub    $0xc,%esp
80103f49:	68 18 9b 10 80       	push   $0x80109b18
80103f4e:	e8 b5 c6 ff ff       	call   80100608 <panic>

  if(mp->imcrp){
80103f53:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103f56:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103f5a:	84 c0                	test   %al,%al
80103f5c:	74 30                	je     80103f8e <mpinit+0x147>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103f5e:	83 ec 08             	sub    $0x8,%esp
80103f61:	6a 70                	push   $0x70
80103f63:	6a 22                	push   $0x22
80103f65:	e8 ae fc ff ff       	call   80103c18 <outb>
80103f6a:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103f6d:	83 ec 0c             	sub    $0xc,%esp
80103f70:	6a 23                	push   $0x23
80103f72:	e8 84 fc ff ff       	call   80103bfb <inb>
80103f77:	83 c4 10             	add    $0x10,%esp
80103f7a:	83 c8 01             	or     $0x1,%eax
80103f7d:	0f b6 c0             	movzbl %al,%eax
80103f80:	83 ec 08             	sub    $0x8,%esp
80103f83:	50                   	push   %eax
80103f84:	6a 23                	push   $0x23
80103f86:	e8 8d fc ff ff       	call   80103c18 <outb>
80103f8b:	83 c4 10             	add    $0x10,%esp
  }
}
80103f8e:	90                   	nop
80103f8f:	c9                   	leave  
80103f90:	c3                   	ret    

80103f91 <outb>:
{
80103f91:	55                   	push   %ebp
80103f92:	89 e5                	mov    %esp,%ebp
80103f94:	83 ec 08             	sub    $0x8,%esp
80103f97:	8b 45 08             	mov    0x8(%ebp),%eax
80103f9a:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f9d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103fa1:	89 d0                	mov    %edx,%eax
80103fa3:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103fa6:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103faa:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103fae:	ee                   	out    %al,(%dx)
}
80103faf:	90                   	nop
80103fb0:	c9                   	leave  
80103fb1:	c3                   	ret    

80103fb2 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103fb2:	f3 0f 1e fb          	endbr32 
80103fb6:	55                   	push   %ebp
80103fb7:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103fb9:	68 ff 00 00 00       	push   $0xff
80103fbe:	6a 21                	push   $0x21
80103fc0:	e8 cc ff ff ff       	call   80103f91 <outb>
80103fc5:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103fc8:	68 ff 00 00 00       	push   $0xff
80103fcd:	68 a1 00 00 00       	push   $0xa1
80103fd2:	e8 ba ff ff ff       	call   80103f91 <outb>
80103fd7:	83 c4 08             	add    $0x8,%esp
}
80103fda:	90                   	nop
80103fdb:	c9                   	leave  
80103fdc:	c3                   	ret    

80103fdd <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103fdd:	f3 0f 1e fb          	endbr32 
80103fe1:	55                   	push   %ebp
80103fe2:	89 e5                	mov    %esp,%ebp
80103fe4:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103fe7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103fee:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ff1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ffa:	8b 10                	mov    (%eax),%edx
80103ffc:	8b 45 08             	mov    0x8(%ebp),%eax
80103fff:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80104001:	e8 e2 d0 ff ff       	call   801010e8 <filealloc>
80104006:	8b 55 08             	mov    0x8(%ebp),%edx
80104009:	89 02                	mov    %eax,(%edx)
8010400b:	8b 45 08             	mov    0x8(%ebp),%eax
8010400e:	8b 00                	mov    (%eax),%eax
80104010:	85 c0                	test   %eax,%eax
80104012:	0f 84 c8 00 00 00    	je     801040e0 <pipealloc+0x103>
80104018:	e8 cb d0 ff ff       	call   801010e8 <filealloc>
8010401d:	8b 55 0c             	mov    0xc(%ebp),%edx
80104020:	89 02                	mov    %eax,(%edx)
80104022:	8b 45 0c             	mov    0xc(%ebp),%eax
80104025:	8b 00                	mov    (%eax),%eax
80104027:	85 c0                	test   %eax,%eax
80104029:	0f 84 b1 00 00 00    	je     801040e0 <pipealloc+0x103>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010402f:	e8 ea ed ff ff       	call   80102e1e <kalloc>
80104034:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104037:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010403b:	0f 84 a2 00 00 00    	je     801040e3 <pipealloc+0x106>
    goto bad;
  p->readopen = 1;
80104041:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104044:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010404b:	00 00 00 
  p->writeopen = 1;
8010404e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104051:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104058:	00 00 00 
  p->nwrite = 0;
8010405b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010405e:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104065:	00 00 00 
  p->nread = 0;
80104068:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010406b:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104072:	00 00 00 
  initlock(&p->lock, "pipe");
80104075:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104078:	83 ec 08             	sub    $0x8,%esp
8010407b:	68 37 9b 10 80       	push   $0x80109b37
80104080:	50                   	push   %eax
80104081:	e8 00 15 00 00       	call   80105586 <initlock>
80104086:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104089:	8b 45 08             	mov    0x8(%ebp),%eax
8010408c:	8b 00                	mov    (%eax),%eax
8010408e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104094:	8b 45 08             	mov    0x8(%ebp),%eax
80104097:	8b 00                	mov    (%eax),%eax
80104099:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010409d:	8b 45 08             	mov    0x8(%ebp),%eax
801040a0:	8b 00                	mov    (%eax),%eax
801040a2:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801040a6:	8b 45 08             	mov    0x8(%ebp),%eax
801040a9:	8b 00                	mov    (%eax),%eax
801040ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040ae:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801040b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801040b4:	8b 00                	mov    (%eax),%eax
801040b6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801040bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801040bf:	8b 00                	mov    (%eax),%eax
801040c1:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801040c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801040c8:	8b 00                	mov    (%eax),%eax
801040ca:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801040ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801040d1:	8b 00                	mov    (%eax),%eax
801040d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040d6:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801040d9:	b8 00 00 00 00       	mov    $0x0,%eax
801040de:	eb 51                	jmp    80104131 <pipealloc+0x154>
    goto bad;
801040e0:	90                   	nop
801040e1:	eb 01                	jmp    801040e4 <pipealloc+0x107>
    goto bad;
801040e3:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
801040e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801040e8:	74 0e                	je     801040f8 <pipealloc+0x11b>
    kfree((char*)p);
801040ea:	83 ec 0c             	sub    $0xc,%esp
801040ed:	ff 75 f4             	pushl  -0xc(%ebp)
801040f0:	e8 8b ec ff ff       	call   80102d80 <kfree>
801040f5:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801040f8:	8b 45 08             	mov    0x8(%ebp),%eax
801040fb:	8b 00                	mov    (%eax),%eax
801040fd:	85 c0                	test   %eax,%eax
801040ff:	74 11                	je     80104112 <pipealloc+0x135>
    fileclose(*f0);
80104101:	8b 45 08             	mov    0x8(%ebp),%eax
80104104:	8b 00                	mov    (%eax),%eax
80104106:	83 ec 0c             	sub    $0xc,%esp
80104109:	50                   	push   %eax
8010410a:	e8 9f d0 ff ff       	call   801011ae <fileclose>
8010410f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104112:	8b 45 0c             	mov    0xc(%ebp),%eax
80104115:	8b 00                	mov    (%eax),%eax
80104117:	85 c0                	test   %eax,%eax
80104119:	74 11                	je     8010412c <pipealloc+0x14f>
    fileclose(*f1);
8010411b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010411e:	8b 00                	mov    (%eax),%eax
80104120:	83 ec 0c             	sub    $0xc,%esp
80104123:	50                   	push   %eax
80104124:	e8 85 d0 ff ff       	call   801011ae <fileclose>
80104129:	83 c4 10             	add    $0x10,%esp
  return -1;
8010412c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104131:	c9                   	leave  
80104132:	c3                   	ret    

80104133 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104133:	f3 0f 1e fb          	endbr32 
80104137:	55                   	push   %ebp
80104138:	89 e5                	mov    %esp,%ebp
8010413a:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
8010413d:	8b 45 08             	mov    0x8(%ebp),%eax
80104140:	83 ec 0c             	sub    $0xc,%esp
80104143:	50                   	push   %eax
80104144:	e8 63 14 00 00       	call   801055ac <acquire>
80104149:	83 c4 10             	add    $0x10,%esp
  if(writable){
8010414c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104150:	74 23                	je     80104175 <pipeclose+0x42>
    p->writeopen = 0;
80104152:	8b 45 08             	mov    0x8(%ebp),%eax
80104155:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
8010415c:	00 00 00 
    wakeup(&p->nread);
8010415f:	8b 45 08             	mov    0x8(%ebp),%eax
80104162:	05 34 02 00 00       	add    $0x234,%eax
80104167:	83 ec 0c             	sub    $0xc,%esp
8010416a:	50                   	push   %eax
8010416b:	e8 bc 10 00 00       	call   8010522c <wakeup>
80104170:	83 c4 10             	add    $0x10,%esp
80104173:	eb 21                	jmp    80104196 <pipeclose+0x63>
  } else {
    p->readopen = 0;
80104175:	8b 45 08             	mov    0x8(%ebp),%eax
80104178:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010417f:	00 00 00 
    wakeup(&p->nwrite);
80104182:	8b 45 08             	mov    0x8(%ebp),%eax
80104185:	05 38 02 00 00       	add    $0x238,%eax
8010418a:	83 ec 0c             	sub    $0xc,%esp
8010418d:	50                   	push   %eax
8010418e:	e8 99 10 00 00       	call   8010522c <wakeup>
80104193:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104196:	8b 45 08             	mov    0x8(%ebp),%eax
80104199:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010419f:	85 c0                	test   %eax,%eax
801041a1:	75 2c                	jne    801041cf <pipeclose+0x9c>
801041a3:	8b 45 08             	mov    0x8(%ebp),%eax
801041a6:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801041ac:	85 c0                	test   %eax,%eax
801041ae:	75 1f                	jne    801041cf <pipeclose+0x9c>
    release(&p->lock);
801041b0:	8b 45 08             	mov    0x8(%ebp),%eax
801041b3:	83 ec 0c             	sub    $0xc,%esp
801041b6:	50                   	push   %eax
801041b7:	e8 62 14 00 00       	call   8010561e <release>
801041bc:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801041bf:	83 ec 0c             	sub    $0xc,%esp
801041c2:	ff 75 08             	pushl  0x8(%ebp)
801041c5:	e8 b6 eb ff ff       	call   80102d80 <kfree>
801041ca:	83 c4 10             	add    $0x10,%esp
801041cd:	eb 10                	jmp    801041df <pipeclose+0xac>
  } else
    release(&p->lock);
801041cf:	8b 45 08             	mov    0x8(%ebp),%eax
801041d2:	83 ec 0c             	sub    $0xc,%esp
801041d5:	50                   	push   %eax
801041d6:	e8 43 14 00 00       	call   8010561e <release>
801041db:	83 c4 10             	add    $0x10,%esp
}
801041de:	90                   	nop
801041df:	90                   	nop
801041e0:	c9                   	leave  
801041e1:	c3                   	ret    

801041e2 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801041e2:	f3 0f 1e fb          	endbr32 
801041e6:	55                   	push   %ebp
801041e7:	89 e5                	mov    %esp,%ebp
801041e9:	53                   	push   %ebx
801041ea:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801041ed:	8b 45 08             	mov    0x8(%ebp),%eax
801041f0:	83 ec 0c             	sub    $0xc,%esp
801041f3:	50                   	push   %eax
801041f4:	e8 b3 13 00 00       	call   801055ac <acquire>
801041f9:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801041fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104203:	e9 ad 00 00 00       	jmp    801042b5 <pipewrite+0xd3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
80104208:	8b 45 08             	mov    0x8(%ebp),%eax
8010420b:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104211:	85 c0                	test   %eax,%eax
80104213:	74 0c                	je     80104221 <pipewrite+0x3f>
80104215:	e8 3c 03 00 00       	call   80104556 <myproc>
8010421a:	8b 40 24             	mov    0x24(%eax),%eax
8010421d:	85 c0                	test   %eax,%eax
8010421f:	74 19                	je     8010423a <pipewrite+0x58>
        release(&p->lock);
80104221:	8b 45 08             	mov    0x8(%ebp),%eax
80104224:	83 ec 0c             	sub    $0xc,%esp
80104227:	50                   	push   %eax
80104228:	e8 f1 13 00 00       	call   8010561e <release>
8010422d:	83 c4 10             	add    $0x10,%esp
        return -1;
80104230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104235:	e9 a9 00 00 00       	jmp    801042e3 <pipewrite+0x101>
      }
      wakeup(&p->nread);
8010423a:	8b 45 08             	mov    0x8(%ebp),%eax
8010423d:	05 34 02 00 00       	add    $0x234,%eax
80104242:	83 ec 0c             	sub    $0xc,%esp
80104245:	50                   	push   %eax
80104246:	e8 e1 0f 00 00       	call   8010522c <wakeup>
8010424b:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010424e:	8b 45 08             	mov    0x8(%ebp),%eax
80104251:	8b 55 08             	mov    0x8(%ebp),%edx
80104254:	81 c2 38 02 00 00    	add    $0x238,%edx
8010425a:	83 ec 08             	sub    $0x8,%esp
8010425d:	50                   	push   %eax
8010425e:	52                   	push   %edx
8010425f:	e8 d6 0e 00 00       	call   8010513a <sleep>
80104264:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104267:	8b 45 08             	mov    0x8(%ebp),%eax
8010426a:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104270:	8b 45 08             	mov    0x8(%ebp),%eax
80104273:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104279:	05 00 02 00 00       	add    $0x200,%eax
8010427e:	39 c2                	cmp    %eax,%edx
80104280:	74 86                	je     80104208 <pipewrite+0x26>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104282:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104285:	8b 45 0c             	mov    0xc(%ebp),%eax
80104288:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010428b:	8b 45 08             	mov    0x8(%ebp),%eax
8010428e:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104294:	8d 48 01             	lea    0x1(%eax),%ecx
80104297:	8b 55 08             	mov    0x8(%ebp),%edx
8010429a:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801042a0:	25 ff 01 00 00       	and    $0x1ff,%eax
801042a5:	89 c1                	mov    %eax,%ecx
801042a7:	0f b6 13             	movzbl (%ebx),%edx
801042aa:	8b 45 08             	mov    0x8(%ebp),%eax
801042ad:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
801042b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801042b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042b8:	3b 45 10             	cmp    0x10(%ebp),%eax
801042bb:	7c aa                	jl     80104267 <pipewrite+0x85>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801042bd:	8b 45 08             	mov    0x8(%ebp),%eax
801042c0:	05 34 02 00 00       	add    $0x234,%eax
801042c5:	83 ec 0c             	sub    $0xc,%esp
801042c8:	50                   	push   %eax
801042c9:	e8 5e 0f 00 00       	call   8010522c <wakeup>
801042ce:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801042d1:	8b 45 08             	mov    0x8(%ebp),%eax
801042d4:	83 ec 0c             	sub    $0xc,%esp
801042d7:	50                   	push   %eax
801042d8:	e8 41 13 00 00       	call   8010561e <release>
801042dd:	83 c4 10             	add    $0x10,%esp
  return n;
801042e0:	8b 45 10             	mov    0x10(%ebp),%eax
}
801042e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042e6:	c9                   	leave  
801042e7:	c3                   	ret    

801042e8 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801042e8:	f3 0f 1e fb          	endbr32 
801042ec:	55                   	push   %ebp
801042ed:	89 e5                	mov    %esp,%ebp
801042ef:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801042f2:	8b 45 08             	mov    0x8(%ebp),%eax
801042f5:	83 ec 0c             	sub    $0xc,%esp
801042f8:	50                   	push   %eax
801042f9:	e8 ae 12 00 00       	call   801055ac <acquire>
801042fe:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104301:	eb 3e                	jmp    80104341 <piperead+0x59>
    if(myproc()->killed){
80104303:	e8 4e 02 00 00       	call   80104556 <myproc>
80104308:	8b 40 24             	mov    0x24(%eax),%eax
8010430b:	85 c0                	test   %eax,%eax
8010430d:	74 19                	je     80104328 <piperead+0x40>
      release(&p->lock);
8010430f:	8b 45 08             	mov    0x8(%ebp),%eax
80104312:	83 ec 0c             	sub    $0xc,%esp
80104315:	50                   	push   %eax
80104316:	e8 03 13 00 00       	call   8010561e <release>
8010431b:	83 c4 10             	add    $0x10,%esp
      return -1;
8010431e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104323:	e9 be 00 00 00       	jmp    801043e6 <piperead+0xfe>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104328:	8b 45 08             	mov    0x8(%ebp),%eax
8010432b:	8b 55 08             	mov    0x8(%ebp),%edx
8010432e:	81 c2 34 02 00 00    	add    $0x234,%edx
80104334:	83 ec 08             	sub    $0x8,%esp
80104337:	50                   	push   %eax
80104338:	52                   	push   %edx
80104339:	e8 fc 0d 00 00       	call   8010513a <sleep>
8010433e:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104341:	8b 45 08             	mov    0x8(%ebp),%eax
80104344:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010434a:	8b 45 08             	mov    0x8(%ebp),%eax
8010434d:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104353:	39 c2                	cmp    %eax,%edx
80104355:	75 0d                	jne    80104364 <piperead+0x7c>
80104357:	8b 45 08             	mov    0x8(%ebp),%eax
8010435a:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104360:	85 c0                	test   %eax,%eax
80104362:	75 9f                	jne    80104303 <piperead+0x1b>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104364:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010436b:	eb 48                	jmp    801043b5 <piperead+0xcd>
    if(p->nread == p->nwrite)
8010436d:	8b 45 08             	mov    0x8(%ebp),%eax
80104370:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104376:	8b 45 08             	mov    0x8(%ebp),%eax
80104379:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010437f:	39 c2                	cmp    %eax,%edx
80104381:	74 3c                	je     801043bf <piperead+0xd7>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104383:	8b 45 08             	mov    0x8(%ebp),%eax
80104386:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010438c:	8d 48 01             	lea    0x1(%eax),%ecx
8010438f:	8b 55 08             	mov    0x8(%ebp),%edx
80104392:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104398:	25 ff 01 00 00       	and    $0x1ff,%eax
8010439d:	89 c1                	mov    %eax,%ecx
8010439f:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801043a5:	01 c2                	add    %eax,%edx
801043a7:	8b 45 08             	mov    0x8(%ebp),%eax
801043aa:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
801043af:	88 02                	mov    %al,(%edx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801043b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801043b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b8:	3b 45 10             	cmp    0x10(%ebp),%eax
801043bb:	7c b0                	jl     8010436d <piperead+0x85>
801043bd:	eb 01                	jmp    801043c0 <piperead+0xd8>
      break;
801043bf:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801043c0:	8b 45 08             	mov    0x8(%ebp),%eax
801043c3:	05 38 02 00 00       	add    $0x238,%eax
801043c8:	83 ec 0c             	sub    $0xc,%esp
801043cb:	50                   	push   %eax
801043cc:	e8 5b 0e 00 00       	call   8010522c <wakeup>
801043d1:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043d4:	8b 45 08             	mov    0x8(%ebp),%eax
801043d7:	83 ec 0c             	sub    $0xc,%esp
801043da:	50                   	push   %eax
801043db:	e8 3e 12 00 00       	call   8010561e <release>
801043e0:	83 c4 10             	add    $0x10,%esp
  return i;
801043e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801043e6:	c9                   	leave  
801043e7:	c3                   	ret    

801043e8 <readeflags>:
{
801043e8:	55                   	push   %ebp
801043e9:	89 e5                	mov    %esp,%ebp
801043eb:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043ee:	9c                   	pushf  
801043ef:	58                   	pop    %eax
801043f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801043f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801043f6:	c9                   	leave  
801043f7:	c3                   	ret    

801043f8 <sti>:
{
801043f8:	55                   	push   %ebp
801043f9:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801043fb:	fb                   	sti    
}
801043fc:	90                   	nop
801043fd:	5d                   	pop    %ebp
801043fe:	c3                   	ret    

801043ff <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801043ff:	f3 0f 1e fb          	endbr32 
80104403:	55                   	push   %ebp
80104404:	89 e5                	mov    %esp,%ebp
80104406:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80104409:	8b 45 0c             	mov    0xc(%ebp),%eax
8010440c:	c1 e8 16             	shr    $0x16,%eax
8010440f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104416:	8b 45 08             	mov    0x8(%ebp),%eax
80104419:	01 d0                	add    %edx,%eax
8010441b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (*pde & PTE_P)
8010441e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104421:	8b 00                	mov    (%eax),%eax
80104423:	83 e0 01             	and    $0x1,%eax
80104426:	85 c0                	test   %eax,%eax
80104428:	74 14                	je     8010443e <walkpgdir+0x3f>
  {
    // if (!alloc)
    // cprintf("page directory is good\n");
    pgtab = (pte_t *)P2V(PTE_ADDR(*pde));
8010442a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010442d:	8b 00                	mov    (%eax),%eax
8010442f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80104434:	05 00 00 00 80       	add    $0x80000000,%eax
80104439:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010443c:	eb 42                	jmp    80104480 <walkpgdir+0x81>
  }
  else
  {
    if (!alloc || (pgtab = (pte_t *)kalloc()) == 0)
8010443e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104442:	74 0e                	je     80104452 <walkpgdir+0x53>
80104444:	e8 d5 e9 ff ff       	call   80102e1e <kalloc>
80104449:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010444c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104450:	75 07                	jne    80104459 <walkpgdir+0x5a>
      return 0;
80104452:	b8 00 00 00 00       	mov    $0x0,%eax
80104457:	eb 3e                	jmp    80104497 <walkpgdir+0x98>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80104459:	83 ec 04             	sub    $0x4,%esp
8010445c:	68 00 10 00 00       	push   $0x1000
80104461:	6a 00                	push   $0x0
80104463:	ff 75 f4             	pushl  -0xc(%ebp)
80104466:	e8 e0 13 00 00       	call   8010584b <memset>
8010446b:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010446e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104471:	05 00 00 00 80       	add    $0x80000000,%eax
80104476:	83 c8 07             	or     $0x7,%eax
80104479:	89 c2                	mov    %eax,%edx
8010447b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010447e:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80104480:	8b 45 0c             	mov    0xc(%ebp),%eax
80104483:	c1 e8 0c             	shr    $0xc,%eax
80104486:	25 ff 03 00 00       	and    $0x3ff,%eax
8010448b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104492:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104495:	01 d0                	add    %edx,%eax
}
80104497:	c9                   	leave  
80104498:	c3                   	ret    

80104499 <pinit>:
extern void trapret(void);

static void wakeup1(void *chan);

void pinit(void)
{
80104499:	f3 0f 1e fb          	endbr32 
8010449d:	55                   	push   %ebp
8010449e:	89 e5                	mov    %esp,%ebp
801044a0:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801044a3:	83 ec 08             	sub    $0x8,%esp
801044a6:	68 3c 9b 10 80       	push   $0x80109b3c
801044ab:	68 c0 5d 11 80       	push   $0x80115dc0
801044b0:	e8 d1 10 00 00       	call   80105586 <initlock>
801044b5:	83 c4 10             	add    $0x10,%esp
}
801044b8:	90                   	nop
801044b9:	c9                   	leave  
801044ba:	c3                   	ret    

801044bb <cpuid>:

// Must be called with interrupts disabled
int cpuid()
{
801044bb:	f3 0f 1e fb          	endbr32 
801044bf:	55                   	push   %ebp
801044c0:	89 e5                	mov    %esp,%ebp
801044c2:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
801044c5:	e8 10 00 00 00       	call   801044da <mycpu>
801044ca:	2d 20 58 11 80       	sub    $0x80115820,%eax
801044cf:	c1 f8 04             	sar    $0x4,%eax
801044d2:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801044d8:	c9                   	leave  
801044d9:	c3                   	ret    

801044da <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu *
mycpu(void)
{
801044da:	f3 0f 1e fb          	endbr32 
801044de:	55                   	push   %ebp
801044df:	89 e5                	mov    %esp,%ebp
801044e1:	83 ec 18             	sub    $0x18,%esp
  int apicid, i;

  if (readeflags() & FL_IF)
801044e4:	e8 ff fe ff ff       	call   801043e8 <readeflags>
801044e9:	25 00 02 00 00       	and    $0x200,%eax
801044ee:	85 c0                	test   %eax,%eax
801044f0:	74 0d                	je     801044ff <mycpu+0x25>
    panic("mycpu called with interrupts enabled\n");
801044f2:	83 ec 0c             	sub    $0xc,%esp
801044f5:	68 44 9b 10 80       	push   $0x80109b44
801044fa:	e8 09 c1 ff ff       	call   80100608 <panic>

  apicid = lapicid();
801044ff:	e8 87 ec ff ff       	call   8010318b <lapicid>
80104504:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i)
80104507:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010450e:	eb 2d                	jmp    8010453d <mycpu+0x63>
  {
    if (cpus[i].apicid == apicid)
80104510:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104513:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80104519:	05 20 58 11 80       	add    $0x80115820,%eax
8010451e:	0f b6 00             	movzbl (%eax),%eax
80104521:	0f b6 c0             	movzbl %al,%eax
80104524:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80104527:	75 10                	jne    80104539 <mycpu+0x5f>
      return &cpus[i];
80104529:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010452c:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80104532:	05 20 58 11 80       	add    $0x80115820,%eax
80104537:	eb 1b                	jmp    80104554 <mycpu+0x7a>
  for (i = 0; i < ncpu; ++i)
80104539:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010453d:	a1 a0 5d 11 80       	mov    0x80115da0,%eax
80104542:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104545:	7c c9                	jl     80104510 <mycpu+0x36>
  }
  panic("unknown apicid\n");
80104547:	83 ec 0c             	sub    $0xc,%esp
8010454a:	68 6a 9b 10 80       	push   $0x80109b6a
8010454f:	e8 b4 c0 ff ff       	call   80100608 <panic>
}
80104554:	c9                   	leave  
80104555:	c3                   	ret    

80104556 <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc *
myproc(void)
{
80104556:	f3 0f 1e fb          	endbr32 
8010455a:	55                   	push   %ebp
8010455b:	89 e5                	mov    %esp,%ebp
8010455d:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80104560:	e8 d3 11 00 00       	call   80105738 <pushcli>
  c = mycpu();
80104565:	e8 70 ff ff ff       	call   801044da <mycpu>
8010456a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
8010456d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104570:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104576:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80104579:	e8 0b 12 00 00       	call   80105789 <popcli>
  return p;
8010457e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80104581:	c9                   	leave  
80104582:	c3                   	ret    

80104583 <allocproc>:
//  If found, change state to EMBRYO and initialize
//  state required to run in the kernel.
//  Otherwise return 0.
static struct proc *
allocproc(void)
{
80104583:	f3 0f 1e fb          	endbr32 
80104587:	55                   	push   %ebp
80104588:	89 e5                	mov    %esp,%ebp
8010458a:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010458d:	83 ec 0c             	sub    $0xc,%esp
80104590:	68 c0 5d 11 80       	push   $0x80115dc0
80104595:	e8 12 10 00 00       	call   801055ac <acquire>
8010459a:	83 c4 10             	add    $0x10,%esp

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010459d:	c7 45 f4 f4 5d 11 80 	movl   $0x80115df4,-0xc(%ebp)
801045a4:	eb 11                	jmp    801045b7 <allocproc+0x34>
    if (p->state == UNUSED)
801045a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a9:	8b 40 0c             	mov    0xc(%eax),%eax
801045ac:	85 c0                	test   %eax,%eax
801045ae:	74 2a                	je     801045da <allocproc+0x57>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045b0:	81 45 f4 e4 00 00 00 	addl   $0xe4,-0xc(%ebp)
801045b7:	81 7d f4 f4 96 11 80 	cmpl   $0x801196f4,-0xc(%ebp)
801045be:	72 e6                	jb     801045a6 <allocproc+0x23>
      goto found;

  release(&ptable.lock);
801045c0:	83 ec 0c             	sub    $0xc,%esp
801045c3:	68 c0 5d 11 80       	push   $0x80115dc0
801045c8:	e8 51 10 00 00       	call   8010561e <release>
801045cd:	83 c4 10             	add    $0x10,%esp
  return 0;
801045d0:	b8 00 00 00 00       	mov    $0x0,%eax
801045d5:	e9 c3 00 00 00       	jmp    8010469d <allocproc+0x11a>
      goto found;
801045da:	90                   	nop
801045db:	f3 0f 1e fb          	endbr32 

found:
  p->state = EMBRYO;
801045df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e2:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801045e9:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801045ee:	8d 50 01             	lea    0x1(%eax),%edx
801045f1:	89 15 00 d0 10 80    	mov    %edx,0x8010d000
801045f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045fa:	89 42 10             	mov    %eax,0x10(%edx)
  p->inClock = 0;
801045fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104600:	c7 80 dc 00 00 00 00 	movl   $0x0,0xdc(%eax)
80104607:	00 00 00 

  release(&ptable.lock);
8010460a:	83 ec 0c             	sub    $0xc,%esp
8010460d:	68 c0 5d 11 80       	push   $0x80115dc0
80104612:	e8 07 10 00 00       	call   8010561e <release>
80104617:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
8010461a:	e8 ff e7 ff ff       	call   80102e1e <kalloc>
8010461f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104622:	89 42 08             	mov    %eax,0x8(%edx)
80104625:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104628:	8b 40 08             	mov    0x8(%eax),%eax
8010462b:	85 c0                	test   %eax,%eax
8010462d:	75 11                	jne    80104640 <allocproc+0xbd>
  {
    p->state = UNUSED;
8010462f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104632:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104639:	b8 00 00 00 00       	mov    $0x0,%eax
8010463e:	eb 5d                	jmp    8010469d <allocproc+0x11a>
  }
  sp = p->kstack + KSTACKSIZE;
80104640:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104643:	8b 40 08             	mov    0x8(%eax),%eax
80104646:	05 00 10 00 00       	add    $0x1000,%eax
8010464b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010464e:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe *)sp;
80104652:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104655:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104658:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
8010465b:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint *)sp = (uint)trapret;
8010465f:	ba c1 6d 10 80       	mov    $0x80106dc1,%edx
80104664:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104667:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104669:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context *)sp;
8010466d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104670:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104673:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104676:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104679:	8b 40 1c             	mov    0x1c(%eax),%eax
8010467c:	83 ec 04             	sub    $0x4,%esp
8010467f:	6a 14                	push   $0x14
80104681:	6a 00                	push   $0x0
80104683:	50                   	push   %eax
80104684:	e8 c2 11 00 00       	call   8010584b <memset>
80104689:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010468c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010468f:	8b 40 1c             	mov    0x1c(%eax),%eax
80104692:	ba f0 50 10 80       	mov    $0x801050f0,%edx
80104697:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
8010469a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010469d:	c9                   	leave  
8010469e:	c3                   	ret    

8010469f <userinit>:

// PAGEBREAK: 32
//  Set up first user process.
void userinit(void)
{
8010469f:	f3 0f 1e fb          	endbr32 
801046a3:	55                   	push   %ebp
801046a4:	89 e5                	mov    %esp,%ebp
801046a6:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801046a9:	e8 d5 fe ff ff       	call   80104583 <allocproc>
801046ae:	89 45 f4             	mov    %eax,-0xc(%ebp)

  initproc = p;
801046b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046b4:	a3 40 d6 10 80       	mov    %eax,0x8010d640
  if ((p->pgdir = setupkvm()) == 0)
801046b9:	e8 c9 3c 00 00       	call   80108387 <setupkvm>
801046be:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046c1:	89 42 04             	mov    %eax,0x4(%edx)
801046c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c7:	8b 40 04             	mov    0x4(%eax),%eax
801046ca:	85 c0                	test   %eax,%eax
801046cc:	75 0d                	jne    801046db <userinit+0x3c>
    panic("userinit: out of memory?");
801046ce:	83 ec 0c             	sub    $0xc,%esp
801046d1:	68 7a 9b 10 80       	push   $0x80109b7a
801046d6:	e8 2d bf ff ff       	call   80100608 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801046db:	ba 2c 00 00 00       	mov    $0x2c,%edx
801046e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e3:	8b 40 04             	mov    0x4(%eax),%eax
801046e6:	83 ec 04             	sub    $0x4,%esp
801046e9:	52                   	push   %edx
801046ea:	68 e0 d4 10 80       	push   $0x8010d4e0
801046ef:	50                   	push   %eax
801046f0:	e8 0b 3f 00 00       	call   80108600 <inituvm>
801046f5:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
801046f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046fb:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104701:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104704:	8b 40 18             	mov    0x18(%eax),%eax
80104707:	83 ec 04             	sub    $0x4,%esp
8010470a:	6a 4c                	push   $0x4c
8010470c:	6a 00                	push   $0x0
8010470e:	50                   	push   %eax
8010470f:	e8 37 11 00 00       	call   8010584b <memset>
80104714:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104717:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010471a:	8b 40 18             	mov    0x18(%eax),%eax
8010471d:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104723:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104726:	8b 40 18             	mov    0x18(%eax),%eax
80104729:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010472f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104732:	8b 50 18             	mov    0x18(%eax),%edx
80104735:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104738:	8b 40 18             	mov    0x18(%eax),%eax
8010473b:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010473f:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104743:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104746:	8b 50 18             	mov    0x18(%eax),%edx
80104749:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010474c:	8b 40 18             	mov    0x18(%eax),%eax
8010474f:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104753:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104757:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010475a:	8b 40 18             	mov    0x18(%eax),%eax
8010475d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104764:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104767:	8b 40 18             	mov    0x18(%eax),%eax
8010476a:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80104771:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104774:	8b 40 18             	mov    0x18(%eax),%eax
80104777:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010477e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104781:	83 c0 6c             	add    $0x6c,%eax
80104784:	83 ec 04             	sub    $0x4,%esp
80104787:	6a 10                	push   $0x10
80104789:	68 93 9b 10 80       	push   $0x80109b93
8010478e:	50                   	push   %eax
8010478f:	e8 d2 12 00 00       	call   80105a66 <safestrcpy>
80104794:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104797:	83 ec 0c             	sub    $0xc,%esp
8010479a:	68 9c 9b 10 80       	push   $0x80109b9c
8010479f:	e8 f5 de ff ff       	call   80102699 <namei>
801047a4:	83 c4 10             	add    $0x10,%esp
801047a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047aa:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801047ad:	83 ec 0c             	sub    $0xc,%esp
801047b0:	68 c0 5d 11 80       	push   $0x80115dc0
801047b5:	e8 f2 0d 00 00       	call   801055ac <acquire>
801047ba:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
801047bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
801047c7:	83 ec 0c             	sub    $0xc,%esp
801047ca:	68 c0 5d 11 80       	push   $0x80115dc0
801047cf:	e8 4a 0e 00 00       	call   8010561e <release>
801047d4:	83 c4 10             	add    $0x10,%esp
}
801047d7:	90                   	nop
801047d8:	c9                   	leave  
801047d9:	c3                   	ret    

801047da <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int growproc(int n)
{
801047da:	f3 0f 1e fb          	endbr32 
801047de:	55                   	push   %ebp
801047df:	89 e5                	mov    %esp,%ebp
801047e1:	53                   	push   %ebx
801047e2:	83 ec 24             	sub    $0x24,%esp
  uint sz;
  struct proc *curproc = myproc();
801047e5:	e8 6c fd ff ff       	call   80104556 <myproc>
801047ea:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // how to encrypt new pages

  sz = curproc->sz;
801047ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
801047f0:	8b 00                	mov    (%eax),%eax
801047f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint oldsize = sz;
801047f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  if (n > 0)
801047fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801047ff:	0f 8e 97 00 00 00    	jle    8010489c <growproc+0xc2>
  {
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104805:	8b 55 08             	mov    0x8(%ebp),%edx
80104808:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010480b:	01 c2                	add    %eax,%edx
8010480d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104810:	8b 40 04             	mov    0x4(%eax),%eax
80104813:	83 ec 04             	sub    $0x4,%esp
80104816:	52                   	push   %edx
80104817:	ff 75 f4             	pushl  -0xc(%ebp)
8010481a:	50                   	push   %eax
8010481b:	e8 25 3f 00 00       	call   80108745 <allocuvm>
80104820:	83 c4 10             	add    $0x10,%esp
80104823:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104826:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010482a:	75 0a                	jne    80104836 <growproc+0x5c>
      return -1;
8010482c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104831:	e9 dc 01 00 00       	jmp    80104a12 <growproc+0x238>

    //
    if (oldsize % PGSIZE == 0)
80104836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104839:	25 ff 0f 00 00       	and    $0xfff,%eax
8010483e:	85 c0                	test   %eax,%eax
80104840:	75 28                	jne    8010486a <growproc+0x90>
    {
      mencrypt((char *)oldsize, n / (PGSIZE));
80104842:	8b 45 08             	mov    0x8(%ebp),%eax
80104845:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
8010484b:	85 c0                	test   %eax,%eax
8010484d:	0f 48 c2             	cmovs  %edx,%eax
80104850:	c1 f8 0c             	sar    $0xc,%eax
80104853:	89 c2                	mov    %eax,%edx
80104855:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104858:	83 ec 08             	sub    $0x8,%esp
8010485b:	52                   	push   %edx
8010485c:	50                   	push   %eax
8010485d:	e8 88 48 00 00       	call   801090ea <mencrypt>
80104862:	83 c4 10             	add    $0x10,%esp
80104865:	e9 8d 01 00 00       	jmp    801049f7 <growproc+0x21d>
    }
    else
    {
      mencrypt((char *)PGROUNDUP((uint)oldsize), n / PGSIZE);
8010486a:	8b 45 08             	mov    0x8(%ebp),%eax
8010486d:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80104873:	85 c0                	test   %eax,%eax
80104875:	0f 48 c2             	cmovs  %edx,%eax
80104878:	c1 f8 0c             	sar    $0xc,%eax
8010487b:	89 c2                	mov    %eax,%edx
8010487d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104880:	05 ff 0f 00 00       	add    $0xfff,%eax
80104885:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010488a:	83 ec 08             	sub    $0x8,%esp
8010488d:	52                   	push   %edx
8010488e:	50                   	push   %eax
8010488f:	e8 56 48 00 00       	call   801090ea <mencrypt>
80104894:	83 c4 10             	add    $0x10,%esp
80104897:	e9 5b 01 00 00       	jmp    801049f7 <growproc+0x21d>
    }
  }
  else if (n < 0)
8010489c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801048a0:	0f 89 51 01 00 00    	jns    801049f7 <growproc+0x21d>
  {
    // iterate through clock and see if any of the nodes' memory was deallocated
    for (int i = 0; i < curproc->inClock; i++)
801048a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801048ad:	e9 05 01 00 00       	jmp    801049b7 <growproc+0x1dd>
    {

      // if node i's memory was deallocated - not sure if this is right
      if ((uint)curproc->nodes[i].pageAddr >= sz + n)
801048b2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
801048b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048b8:	89 d0                	mov    %edx,%eax
801048ba:	01 c0                	add    %eax,%eax
801048bc:	01 d0                	add    %edx,%eax
801048be:	c1 e0 02             	shl    $0x2,%eax
801048c1:	01 c8                	add    %ecx,%eax
801048c3:	83 e8 80             	sub    $0xffffff80,%eax
801048c6:	8b 00                	mov    (%eax),%eax
801048c8:	89 c1                	mov    %eax,%ecx
801048ca:	8b 55 08             	mov    0x8(%ebp),%edx
801048cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048d0:	01 d0                	add    %edx,%eax
801048d2:	39 c1                	cmp    %eax,%ecx
801048d4:	0f 82 d9 00 00 00    	jb     801049b3 <growproc+0x1d9>
      {

        // shift nodes to replace i

        // if there are nodes to the right of i
        if (i < curproc->inClock - 1)
801048da:	8b 45 e8             	mov    -0x18(%ebp),%eax
801048dd:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
801048e3:	83 e8 01             	sub    $0x1,%eax
801048e6:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801048e9:	0f 8d 91 00 00 00    	jge    80104980 <growproc+0x1a6>
        {
          // iterate through nodes to the right of i
          for (int j = i; j < curproc->inClock; j++)
801048ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
801048f5:	eb 75                	jmp    8010496c <growproc+0x192>
          {
            // if j is the last node
            if (j == curproc->inClock - 1)
801048f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801048fa:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
80104900:	83 e8 01             	sub    $0x1,%eax
80104903:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104906:	75 31                	jne    80104939 <growproc+0x15f>
            {
              curproc->nodes[j].pageAddr = (char *)-1;
80104908:	8b 4d e8             	mov    -0x18(%ebp),%ecx
8010490b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010490e:	89 d0                	mov    %edx,%eax
80104910:	01 c0                	add    %eax,%eax
80104912:	01 d0                	add    %edx,%eax
80104914:	c1 e0 02             	shl    $0x2,%eax
80104917:	01 c8                	add    %ecx,%eax
80104919:	83 e8 80             	sub    $0xffffff80,%eax
8010491c:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
              curproc->currInd = curproc->inClock - 1;
80104922:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104925:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
8010492b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010492e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104931:	89 90 e0 00 00 00    	mov    %edx,0xe0(%eax)
80104937:	eb 2f                	jmp    80104968 <growproc+0x18e>
            }
            // if there are nodes to the right of j, shift addr to j
            else
            {
              curproc->nodes[j].pageAddr = curproc->nodes[j + 1].pageAddr;
80104939:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010493c:	8d 50 01             	lea    0x1(%eax),%edx
8010493f:	8b 4d e8             	mov    -0x18(%ebp),%ecx
80104942:	89 d0                	mov    %edx,%eax
80104944:	01 c0                	add    %eax,%eax
80104946:	01 d0                	add    %edx,%eax
80104948:	c1 e0 02             	shl    $0x2,%eax
8010494b:	01 c8                	add    %ecx,%eax
8010494d:	83 e8 80             	sub    $0xffffff80,%eax
80104950:	8b 08                	mov    (%eax),%ecx
80104952:	8b 5d e8             	mov    -0x18(%ebp),%ebx
80104955:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104958:	89 d0                	mov    %edx,%eax
8010495a:	01 c0                	add    %eax,%eax
8010495c:	01 d0                	add    %edx,%eax
8010495e:	c1 e0 02             	shl    $0x2,%eax
80104961:	01 d8                	add    %ebx,%eax
80104963:	83 e8 80             	sub    $0xffffff80,%eax
80104966:	89 08                	mov    %ecx,(%eax)
          for (int j = i; j < curproc->inClock; j++)
80104968:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010496c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010496f:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
80104975:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104978:	0f 8c 79 ff ff ff    	jl     801048f7 <growproc+0x11d>
8010497e:	eb 1a                	jmp    8010499a <growproc+0x1c0>
          }
        }
        else
        {

          curproc->nodes[i].pageAddr = (char *)-1;
80104980:	8b 4d e8             	mov    -0x18(%ebp),%ecx
80104983:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104986:	89 d0                	mov    %edx,%eax
80104988:	01 c0                	add    %eax,%eax
8010498a:	01 d0                	add    %edx,%eax
8010498c:	c1 e0 02             	shl    $0x2,%eax
8010498f:	01 c8                	add    %ecx,%eax
80104991:	83 e8 80             	sub    $0xffffff80,%eax
80104994:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
        }
        i--;
8010499a:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        curproc->inClock--;
8010499e:	8b 45 e8             	mov    -0x18(%ebp),%eax
801049a1:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
801049a7:	8d 50 ff             	lea    -0x1(%eax),%edx
801049aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
801049ad:	89 90 dc 00 00 00    	mov    %edx,0xdc(%eax)
    for (int i = 0; i < curproc->inClock; i++)
801049b3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801049b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801049ba:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
801049c0:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801049c3:	0f 8c e9 fe ff ff    	jl     801048b2 <growproc+0xd8>
      }
    }

    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801049c9:	8b 55 08             	mov    0x8(%ebp),%edx
801049cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049cf:	01 c2                	add    %eax,%edx
801049d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801049d4:	8b 40 04             	mov    0x4(%eax),%eax
801049d7:	83 ec 04             	sub    $0x4,%esp
801049da:	52                   	push   %edx
801049db:	ff 75 f4             	pushl  -0xc(%ebp)
801049de:	50                   	push   %eax
801049df:	e8 6a 3e 00 00       	call   8010884e <deallocuvm>
801049e4:	83 c4 10             	add    $0x10,%esp
801049e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801049ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801049ee:	75 07                	jne    801049f7 <growproc+0x21d>
      return -1;
801049f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049f5:	eb 1b                	jmp    80104a12 <growproc+0x238>
  }
  curproc->sz = sz;
801049f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801049fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049fd:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
801049ff:	83 ec 0c             	sub    $0xc,%esp
80104a02:	ff 75 e8             	pushl  -0x18(%ebp)
80104a05:	e8 53 3a 00 00       	call   8010845d <switchuvm>
80104a0a:	83 c4 10             	add    $0x10,%esp
  return 0;
80104a0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a15:	c9                   	leave  
80104a16:	c3                   	ret    

80104a17 <fork>:

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int fork(void)
{
80104a17:	f3 0f 1e fb          	endbr32 
80104a1b:	55                   	push   %ebp
80104a1c:	89 e5                	mov    %esp,%ebp
80104a1e:	57                   	push   %edi
80104a1f:	56                   	push   %esi
80104a20:	53                   	push   %ebx
80104a21:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80104a24:	e8 2d fb ff ff       	call   80104556 <myproc>
80104a29:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Allocate process.
  if ((np = allocproc()) == 0)
80104a2c:	e8 52 fb ff ff       	call   80104583 <allocproc>
80104a31:	89 45 d8             	mov    %eax,-0x28(%ebp)
80104a34:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80104a38:	75 0a                	jne    80104a44 <fork+0x2d>
  {
    return -1;
80104a3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a3f:	e9 9c 02 00 00       	jmp    80104ce0 <fork+0x2c9>
  }

  // Copy process state from proc.
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
80104a44:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104a47:	8b 10                	mov    (%eax),%edx
80104a49:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104a4c:	8b 40 04             	mov    0x4(%eax),%eax
80104a4f:	83 ec 08             	sub    $0x8,%esp
80104a52:	52                   	push   %edx
80104a53:	50                   	push   %eax
80104a54:	e8 a3 3f 00 00       	call   801089fc <copyuvm>
80104a59:	83 c4 10             	add    $0x10,%esp
80104a5c:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104a5f:	89 42 04             	mov    %eax,0x4(%edx)
80104a62:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104a65:	8b 40 04             	mov    0x4(%eax),%eax
80104a68:	85 c0                	test   %eax,%eax
80104a6a:	75 30                	jne    80104a9c <fork+0x85>
  {
    kfree(np->kstack);
80104a6c:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104a6f:	8b 40 08             	mov    0x8(%eax),%eax
80104a72:	83 ec 0c             	sub    $0xc,%esp
80104a75:	50                   	push   %eax
80104a76:	e8 05 e3 ff ff       	call   80102d80 <kfree>
80104a7b:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104a7e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104a81:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104a88:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104a8b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

    return -1;
80104a92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a97:	e9 44 02 00 00       	jmp    80104ce0 <fork+0x2c9>
  }

  //create the clock queue for the new proc
  np->currInd = curproc->currInd+3;
80104a9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104a9f:	8b 80 e0 00 00 00    	mov    0xe0(%eax),%eax
80104aa5:	8d 50 03             	lea    0x3(%eax),%edx
80104aa8:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104aab:	89 90 e0 00 00 00    	mov    %edx,0xe0(%eax)
  np->inClock = curproc->inClock;
80104ab1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104ab4:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
80104aba:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104abd:	89 90 dc 00 00 00    	mov    %edx,0xdc(%eax)

  // deep copy queue to child
  for (int i = 0; i < curproc->inClock; i++)
80104ac3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80104aca:	e9 0f 01 00 00       	jmp    80104bde <fork+0x1c7>
  {

    pte_t *p = walkpgdir(curproc->pgdir, curproc->nodes[i].pageAddr, 0);
80104acf:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80104ad2:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104ad5:	89 d0                	mov    %edx,%eax
80104ad7:	01 c0                	add    %eax,%eax
80104ad9:	01 d0                	add    %edx,%eax
80104adb:	c1 e0 02             	shl    $0x2,%eax
80104ade:	01 c8                	add    %ecx,%eax
80104ae0:	83 e8 80             	sub    $0xffffff80,%eax
80104ae3:	8b 10                	mov    (%eax),%edx
80104ae5:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104ae8:	8b 40 04             	mov    0x4(%eax),%eax
80104aeb:	83 ec 04             	sub    $0x4,%esp
80104aee:	6a 00                	push   $0x0
80104af0:	52                   	push   %edx
80104af1:	50                   	push   %eax
80104af2:	e8 08 f9 ff ff       	call   801043ff <walkpgdir>
80104af7:	83 c4 10             	add    $0x10,%esp
80104afa:	89 45 d0             	mov    %eax,-0x30(%ebp)

    np->nodes[i].key = curproc->nodes[i].key;
80104afd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80104b00:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104b03:	89 d0                	mov    %edx,%eax
80104b05:	01 c0                	add    %eax,%eax
80104b07:	01 d0                	add    %edx,%eax
80104b09:	c1 e0 02             	shl    $0x2,%eax
80104b0c:	01 c8                	add    %ecx,%eax
80104b0e:	83 c0 7c             	add    $0x7c,%eax
80104b11:	8b 08                	mov    (%eax),%ecx
80104b13:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80104b16:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104b19:	89 d0                	mov    %edx,%eax
80104b1b:	01 c0                	add    %eax,%eax
80104b1d:	01 d0                	add    %edx,%eax
80104b1f:	c1 e0 02             	shl    $0x2,%eax
80104b22:	01 d8                	add    %ebx,%eax
80104b24:	83 c0 7c             	add    $0x7c,%eax
80104b27:	89 08                	mov    %ecx,(%eax)
    np->nodes[i].next = curproc->nodes[i].next;
80104b29:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80104b2c:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104b2f:	89 d0                	mov    %edx,%eax
80104b31:	01 c0                	add    %eax,%eax
80104b33:	01 d0                	add    %edx,%eax
80104b35:	c1 e0 02             	shl    $0x2,%eax
80104b38:	01 c8                	add    %ecx,%eax
80104b3a:	05 84 00 00 00       	add    $0x84,%eax
80104b3f:	8b 08                	mov    (%eax),%ecx
80104b41:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80104b44:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104b47:	89 d0                	mov    %edx,%eax
80104b49:	01 c0                	add    %eax,%eax
80104b4b:	01 d0                	add    %edx,%eax
80104b4d:	c1 e0 02             	shl    $0x2,%eax
80104b50:	01 d8                	add    %ebx,%eax
80104b52:	05 84 00 00 00       	add    $0x84,%eax
80104b57:	89 08                	mov    %ecx,(%eax)
    np->nodes[i].pageAddr = curproc->nodes[i].pageAddr;
80104b59:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80104b5c:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104b5f:	89 d0                	mov    %edx,%eax
80104b61:	01 c0                	add    %eax,%eax
80104b63:	01 d0                	add    %edx,%eax
80104b65:	c1 e0 02             	shl    $0x2,%eax
80104b68:	01 c8                	add    %ecx,%eax
80104b6a:	83 e8 80             	sub    $0xffffff80,%eax
80104b6d:	8b 08                	mov    (%eax),%ecx
80104b6f:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80104b72:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104b75:	89 d0                	mov    %edx,%eax
80104b77:	01 c0                	add    %eax,%eax
80104b79:	01 d0                	add    %edx,%eax
80104b7b:	c1 e0 02             	shl    $0x2,%eax
80104b7e:	01 d8                	add    %ebx,%eax
80104b80:	83 e8 80             	sub    $0xffffff80,%eax
80104b83:	89 08                	mov    %ecx,(%eax)

    pte_t *c = walkpgdir(np->pgdir, np->nodes[i].pageAddr, 0);
80104b85:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80104b88:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104b8b:	89 d0                	mov    %edx,%eax
80104b8d:	01 c0                	add    %eax,%eax
80104b8f:	01 d0                	add    %edx,%eax
80104b91:	c1 e0 02             	shl    $0x2,%eax
80104b94:	01 c8                	add    %ecx,%eax
80104b96:	83 e8 80             	sub    $0xffffff80,%eax
80104b99:	8b 10                	mov    (%eax),%edx
80104b9b:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104b9e:	8b 40 04             	mov    0x4(%eax),%eax
80104ba1:	83 ec 04             	sub    $0x4,%esp
80104ba4:	6a 00                	push   $0x0
80104ba6:	52                   	push   %edx
80104ba7:	50                   	push   %eax
80104ba8:	e8 52 f8 ff ff       	call   801043ff <walkpgdir>
80104bad:	83 c4 10             	add    $0x10,%esp
80104bb0:	89 45 cc             	mov    %eax,-0x34(%ebp)

    if (!(*p & PTE_P))
80104bb3:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104bb6:	8b 00                	mov    (%eax),%eax
80104bb8:	83 e0 01             	and    $0x1,%eax
80104bbb:	85 c0                	test   %eax,%eax
80104bbd:	75 1b                	jne    80104bda <fork+0x1c3>
    {
      if ((*c & PTE_P))
80104bbf:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104bc2:	8b 00                	mov    (%eax),%eax
80104bc4:	83 e0 01             	and    $0x1,%eax
80104bc7:	85 c0                	test   %eax,%eax
80104bc9:	74 0f                	je     80104bda <fork+0x1c3>
      {
        *c = *c & ~PTE_P;
80104bcb:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104bce:	8b 00                	mov    (%eax),%eax
80104bd0:	83 e0 fe             	and    $0xfffffffe,%eax
80104bd3:	89 c2                	mov    %eax,%edx
80104bd5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104bd8:	89 10                	mov    %edx,(%eax)
  for (int i = 0; i < curproc->inClock; i++)
80104bda:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80104bde:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104be1:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
80104be7:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80104bea:	0f 8c df fe ff ff    	jl     80104acf <fork+0xb8>
      }
    }
  }

  np->sz = curproc->sz;
80104bf0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104bf3:	8b 10                	mov    (%eax),%edx
80104bf5:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104bf8:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
80104bfa:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104bfd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104c00:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
80104c03:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104c06:	8b 48 18             	mov    0x18(%eax),%ecx
80104c09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104c0c:	8b 40 18             	mov    0x18(%eax),%eax
80104c0f:	89 c2                	mov    %eax,%edx
80104c11:	89 cb                	mov    %ecx,%ebx
80104c13:	b8 13 00 00 00       	mov    $0x13,%eax
80104c18:	89 d7                	mov    %edx,%edi
80104c1a:	89 de                	mov    %ebx,%esi
80104c1c:	89 c1                	mov    %eax,%ecx
80104c1e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104c20:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104c23:	8b 40 18             	mov    0x18(%eax),%eax
80104c26:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for (i = 0; i < NOFILE; i++)
80104c2d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104c34:	eb 3b                	jmp    80104c71 <fork+0x25a>
    if (curproc->ofile[i])
80104c36:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104c39:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104c3c:	83 c2 08             	add    $0x8,%edx
80104c3f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c43:	85 c0                	test   %eax,%eax
80104c45:	74 26                	je     80104c6d <fork+0x256>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104c47:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104c4a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104c4d:	83 c2 08             	add    $0x8,%edx
80104c50:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c54:	83 ec 0c             	sub    $0xc,%esp
80104c57:	50                   	push   %eax
80104c58:	e8 fc c4 ff ff       	call   80101159 <filedup>
80104c5d:	83 c4 10             	add    $0x10,%esp
80104c60:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104c63:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104c66:	83 c1 08             	add    $0x8,%ecx
80104c69:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for (i = 0; i < NOFILE; i++)
80104c6d:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104c71:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104c75:	7e bf                	jle    80104c36 <fork+0x21f>
  np->cwd = idup(curproc->cwd);
80104c77:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104c7a:	8b 40 68             	mov    0x68(%eax),%eax
80104c7d:	83 ec 0c             	sub    $0xc,%esp
80104c80:	50                   	push   %eax
80104c81:	e8 6a ce ff ff       	call   80101af0 <idup>
80104c86:	83 c4 10             	add    $0x10,%esp
80104c89:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104c8c:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104c8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104c92:	8d 50 6c             	lea    0x6c(%eax),%edx
80104c95:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104c98:	83 c0 6c             	add    $0x6c,%eax
80104c9b:	83 ec 04             	sub    $0x4,%esp
80104c9e:	6a 10                	push   $0x10
80104ca0:	52                   	push   %edx
80104ca1:	50                   	push   %eax
80104ca2:	e8 bf 0d 00 00       	call   80105a66 <safestrcpy>
80104ca7:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80104caa:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104cad:	8b 40 10             	mov    0x10(%eax),%eax
80104cb0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

  acquire(&ptable.lock);
80104cb3:	83 ec 0c             	sub    $0xc,%esp
80104cb6:	68 c0 5d 11 80       	push   $0x80115dc0
80104cbb:	e8 ec 08 00 00       	call   801055ac <acquire>
80104cc0:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
80104cc3:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104cc6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104ccd:	83 ec 0c             	sub    $0xc,%esp
80104cd0:	68 c0 5d 11 80       	push   $0x80115dc0
80104cd5:	e8 44 09 00 00       	call   8010561e <release>
80104cda:	83 c4 10             	add    $0x10,%esp

  return pid;
80104cdd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
80104ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ce3:	5b                   	pop    %ebx
80104ce4:	5e                   	pop    %esi
80104ce5:	5f                   	pop    %edi
80104ce6:	5d                   	pop    %ebp
80104ce7:	c3                   	ret    

80104ce8 <exit>:

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void exit(void)
{
80104ce8:	f3 0f 1e fb          	endbr32 
80104cec:	55                   	push   %ebp
80104ced:	89 e5                	mov    %esp,%ebp
80104cef:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104cf2:	e8 5f f8 ff ff       	call   80104556 <myproc>
80104cf7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if (curproc == initproc)
80104cfa:	a1 40 d6 10 80       	mov    0x8010d640,%eax
80104cff:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104d02:	75 0d                	jne    80104d11 <exit+0x29>
    panic("init exiting");
80104d04:	83 ec 0c             	sub    $0xc,%esp
80104d07:	68 9e 9b 10 80       	push   $0x80109b9e
80104d0c:	e8 f7 b8 ff ff       	call   80100608 <panic>

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++)
80104d11:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104d18:	eb 3f                	jmp    80104d59 <exit+0x71>
  {
    if (curproc->ofile[fd])
80104d1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d1d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104d20:	83 c2 08             	add    $0x8,%edx
80104d23:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104d27:	85 c0                	test   %eax,%eax
80104d29:	74 2a                	je     80104d55 <exit+0x6d>
    {
      fileclose(curproc->ofile[fd]);
80104d2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104d31:	83 c2 08             	add    $0x8,%edx
80104d34:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104d38:	83 ec 0c             	sub    $0xc,%esp
80104d3b:	50                   	push   %eax
80104d3c:	e8 6d c4 ff ff       	call   801011ae <fileclose>
80104d41:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
80104d44:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d47:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104d4a:	83 c2 08             	add    $0x8,%edx
80104d4d:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104d54:	00 
  for (fd = 0; fd < NOFILE; fd++)
80104d55:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104d59:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104d5d:	7e bb                	jle    80104d1a <exit+0x32>
    }
  }

  begin_op();
80104d5f:	e8 99 e9 ff ff       	call   801036fd <begin_op>
  iput(curproc->cwd);
80104d64:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d67:	8b 40 68             	mov    0x68(%eax),%eax
80104d6a:	83 ec 0c             	sub    $0xc,%esp
80104d6d:	50                   	push   %eax
80104d6e:	e8 24 cf ff ff       	call   80101c97 <iput>
80104d73:	83 c4 10             	add    $0x10,%esp
  end_op();
80104d76:	e8 12 ea ff ff       	call   8010378d <end_op>
  curproc->cwd = 0;
80104d7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d7e:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104d85:	83 ec 0c             	sub    $0xc,%esp
80104d88:	68 c0 5d 11 80       	push   $0x80115dc0
80104d8d:	e8 1a 08 00 00       	call   801055ac <acquire>
80104d92:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104d95:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d98:	8b 40 14             	mov    0x14(%eax),%eax
80104d9b:	83 ec 0c             	sub    $0xc,%esp
80104d9e:	50                   	push   %eax
80104d9f:	e8 41 04 00 00       	call   801051e5 <wakeup1>
80104da4:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104da7:	c7 45 f4 f4 5d 11 80 	movl   $0x80115df4,-0xc(%ebp)
80104dae:	eb 3a                	jmp    80104dea <exit+0x102>
  {
    if (p->parent == curproc)
80104db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104db3:	8b 40 14             	mov    0x14(%eax),%eax
80104db6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104db9:	75 28                	jne    80104de3 <exit+0xfb>
    {
      p->parent = initproc;
80104dbb:	8b 15 40 d6 10 80    	mov    0x8010d640,%edx
80104dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dc4:	89 50 14             	mov    %edx,0x14(%eax)
      if (p->state == ZOMBIE)
80104dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dca:	8b 40 0c             	mov    0xc(%eax),%eax
80104dcd:	83 f8 05             	cmp    $0x5,%eax
80104dd0:	75 11                	jne    80104de3 <exit+0xfb>
        wakeup1(initproc);
80104dd2:	a1 40 d6 10 80       	mov    0x8010d640,%eax
80104dd7:	83 ec 0c             	sub    $0xc,%esp
80104dda:	50                   	push   %eax
80104ddb:	e8 05 04 00 00       	call   801051e5 <wakeup1>
80104de0:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104de3:	81 45 f4 e4 00 00 00 	addl   $0xe4,-0xc(%ebp)
80104dea:	81 7d f4 f4 96 11 80 	cmpl   $0x801196f4,-0xc(%ebp)
80104df1:	72 bd                	jb     80104db0 <exit+0xc8>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104df3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104df6:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104dfd:	e8 f3 01 00 00       	call   80104ff5 <sched>
  panic("zombie exit");
80104e02:	83 ec 0c             	sub    $0xc,%esp
80104e05:	68 ab 9b 10 80       	push   $0x80109bab
80104e0a:	e8 f9 b7 ff ff       	call   80100608 <panic>

80104e0f <wait>:
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int wait(void)
{
80104e0f:	f3 0f 1e fb          	endbr32 
80104e13:	55                   	push   %ebp
80104e14:	89 e5                	mov    %esp,%ebp
80104e16:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104e19:	e8 38 f7 ff ff       	call   80104556 <myproc>
80104e1e:	89 45 ec             	mov    %eax,-0x14(%ebp)

  acquire(&ptable.lock);
80104e21:	83 ec 0c             	sub    $0xc,%esp
80104e24:	68 c0 5d 11 80       	push   $0x80115dc0
80104e29:	e8 7e 07 00 00       	call   801055ac <acquire>
80104e2e:	83 c4 10             	add    $0x10,%esp
  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
80104e31:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e38:	c7 45 f4 f4 5d 11 80 	movl   $0x80115df4,-0xc(%ebp)
80104e3f:	e9 a4 00 00 00       	jmp    80104ee8 <wait+0xd9>
    {
      if (p->parent != curproc)
80104e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e47:	8b 40 14             	mov    0x14(%eax),%eax
80104e4a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104e4d:	0f 85 8d 00 00 00    	jne    80104ee0 <wait+0xd1>
        continue;
      havekids = 1;
80104e53:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if (p->state == ZOMBIE)
80104e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e5d:	8b 40 0c             	mov    0xc(%eax),%eax
80104e60:	83 f8 05             	cmp    $0x5,%eax
80104e63:	75 7c                	jne    80104ee1 <wait+0xd2>
      {
        // Found one.
        pid = p->pid;
80104e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e68:	8b 40 10             	mov    0x10(%eax),%eax
80104e6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e71:	8b 40 08             	mov    0x8(%eax),%eax
80104e74:	83 ec 0c             	sub    $0xc,%esp
80104e77:	50                   	push   %eax
80104e78:	e8 03 df ff ff       	call   80102d80 <kfree>
80104e7d:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e83:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e8d:	8b 40 04             	mov    0x4(%eax),%eax
80104e90:	83 ec 0c             	sub    $0xc,%esp
80104e93:	50                   	push   %eax
80104e94:	e8 7f 3a 00 00       	call   80108918 <freevm>
80104e99:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
80104e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e9f:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ea9:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eb3:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eba:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104ecb:	83 ec 0c             	sub    $0xc,%esp
80104ece:	68 c0 5d 11 80       	push   $0x80115dc0
80104ed3:	e8 46 07 00 00       	call   8010561e <release>
80104ed8:	83 c4 10             	add    $0x10,%esp
        return pid;
80104edb:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104ede:	eb 54                	jmp    80104f34 <wait+0x125>
        continue;
80104ee0:	90                   	nop
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ee1:	81 45 f4 e4 00 00 00 	addl   $0xe4,-0xc(%ebp)
80104ee8:	81 7d f4 f4 96 11 80 	cmpl   $0x801196f4,-0xc(%ebp)
80104eef:	0f 82 4f ff ff ff    	jb     80104e44 <wait+0x35>
      }
    }

    // No point waiting if we don't have any children.
    if (!havekids || curproc->killed)
80104ef5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104ef9:	74 0a                	je     80104f05 <wait+0xf6>
80104efb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104efe:	8b 40 24             	mov    0x24(%eax),%eax
80104f01:	85 c0                	test   %eax,%eax
80104f03:	74 17                	je     80104f1c <wait+0x10d>
    {
      release(&ptable.lock);
80104f05:	83 ec 0c             	sub    $0xc,%esp
80104f08:	68 c0 5d 11 80       	push   $0x80115dc0
80104f0d:	e8 0c 07 00 00       	call   8010561e <release>
80104f12:	83 c4 10             	add    $0x10,%esp
      return -1;
80104f15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f1a:	eb 18                	jmp    80104f34 <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
80104f1c:	83 ec 08             	sub    $0x8,%esp
80104f1f:	68 c0 5d 11 80       	push   $0x80115dc0
80104f24:	ff 75 ec             	pushl  -0x14(%ebp)
80104f27:	e8 0e 02 00 00       	call   8010513a <sleep>
80104f2c:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104f2f:	e9 fd fe ff ff       	jmp    80104e31 <wait+0x22>
  }
}
80104f34:	c9                   	leave  
80104f35:	c3                   	ret    

80104f36 <scheduler>:
//   - choose a process to run
//   - swtch to start running that process
//   - eventually that process transfers control
//       via swtch back to the scheduler.
void scheduler(void)
{
80104f36:	f3 0f 1e fb          	endbr32 
80104f3a:	55                   	push   %ebp
80104f3b:	89 e5                	mov    %esp,%ebp
80104f3d:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80104f40:	e8 95 f5 ff ff       	call   801044da <mycpu>
80104f45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
80104f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f4b:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104f52:	00 00 00 

  for (;;)
  {
    // Enable interrupts on this processor.
    sti();
80104f55:	e8 9e f4 ff ff       	call   801043f8 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104f5a:	83 ec 0c             	sub    $0xc,%esp
80104f5d:	68 c0 5d 11 80       	push   $0x80115dc0
80104f62:	e8 45 06 00 00       	call   801055ac <acquire>
80104f67:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f6a:	c7 45 f4 f4 5d 11 80 	movl   $0x80115df4,-0xc(%ebp)
80104f71:	eb 64                	jmp    80104fd7 <scheduler+0xa1>
    {
      if (p->state != RUNNABLE)
80104f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f76:	8b 40 0c             	mov    0xc(%eax),%eax
80104f79:	83 f8 03             	cmp    $0x3,%eax
80104f7c:	75 51                	jne    80104fcf <scheduler+0x99>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80104f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f81:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f84:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
80104f8a:	83 ec 0c             	sub    $0xc,%esp
80104f8d:	ff 75 f4             	pushl  -0xc(%ebp)
80104f90:	e8 c8 34 00 00       	call   8010845d <switchuvm>
80104f95:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f9b:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
80104fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fa5:	8b 40 1c             	mov    0x1c(%eax),%eax
80104fa8:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104fab:	83 c2 04             	add    $0x4,%edx
80104fae:	83 ec 08             	sub    $0x8,%esp
80104fb1:	50                   	push   %eax
80104fb2:	52                   	push   %edx
80104fb3:	e8 27 0b 00 00       	call   80105adf <swtch>
80104fb8:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104fbb:	e8 80 34 00 00       	call   80108440 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80104fc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fc3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104fca:	00 00 00 
80104fcd:	eb 01                	jmp    80104fd0 <scheduler+0x9a>
        continue;
80104fcf:	90                   	nop
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104fd0:	81 45 f4 e4 00 00 00 	addl   $0xe4,-0xc(%ebp)
80104fd7:	81 7d f4 f4 96 11 80 	cmpl   $0x801196f4,-0xc(%ebp)
80104fde:	72 93                	jb     80104f73 <scheduler+0x3d>
    }
    release(&ptable.lock);
80104fe0:	83 ec 0c             	sub    $0xc,%esp
80104fe3:	68 c0 5d 11 80       	push   $0x80115dc0
80104fe8:	e8 31 06 00 00       	call   8010561e <release>
80104fed:	83 c4 10             	add    $0x10,%esp
    sti();
80104ff0:	e9 60 ff ff ff       	jmp    80104f55 <scheduler+0x1f>

80104ff5 <sched>:
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void sched(void)
{
80104ff5:	f3 0f 1e fb          	endbr32 
80104ff9:	55                   	push   %ebp
80104ffa:	89 e5                	mov    %esp,%ebp
80104ffc:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
80104fff:	e8 52 f5 ff ff       	call   80104556 <myproc>
80105004:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if (!holding(&ptable.lock))
80105007:	83 ec 0c             	sub    $0xc,%esp
8010500a:	68 c0 5d 11 80       	push   $0x80115dc0
8010500f:	e8 df 06 00 00       	call   801056f3 <holding>
80105014:	83 c4 10             	add    $0x10,%esp
80105017:	85 c0                	test   %eax,%eax
80105019:	75 0d                	jne    80105028 <sched+0x33>
    panic("sched ptable.lock");
8010501b:	83 ec 0c             	sub    $0xc,%esp
8010501e:	68 b7 9b 10 80       	push   $0x80109bb7
80105023:	e8 e0 b5 ff ff       	call   80100608 <panic>
  if (mycpu()->ncli != 1)
80105028:	e8 ad f4 ff ff       	call   801044da <mycpu>
8010502d:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105033:	83 f8 01             	cmp    $0x1,%eax
80105036:	74 0d                	je     80105045 <sched+0x50>
    panic("sched locks");
80105038:	83 ec 0c             	sub    $0xc,%esp
8010503b:	68 c9 9b 10 80       	push   $0x80109bc9
80105040:	e8 c3 b5 ff ff       	call   80100608 <panic>
  if (p->state == RUNNING)
80105045:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105048:	8b 40 0c             	mov    0xc(%eax),%eax
8010504b:	83 f8 04             	cmp    $0x4,%eax
8010504e:	75 0d                	jne    8010505d <sched+0x68>
    panic("sched running");
80105050:	83 ec 0c             	sub    $0xc,%esp
80105053:	68 d5 9b 10 80       	push   $0x80109bd5
80105058:	e8 ab b5 ff ff       	call   80100608 <panic>
  if (readeflags() & FL_IF)
8010505d:	e8 86 f3 ff ff       	call   801043e8 <readeflags>
80105062:	25 00 02 00 00       	and    $0x200,%eax
80105067:	85 c0                	test   %eax,%eax
80105069:	74 0d                	je     80105078 <sched+0x83>
    panic("sched interruptible");
8010506b:	83 ec 0c             	sub    $0xc,%esp
8010506e:	68 e3 9b 10 80       	push   $0x80109be3
80105073:	e8 90 b5 ff ff       	call   80100608 <panic>
  intena = mycpu()->intena;
80105078:	e8 5d f4 ff ff       	call   801044da <mycpu>
8010507d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80105083:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
80105086:	e8 4f f4 ff ff       	call   801044da <mycpu>
8010508b:	8b 40 04             	mov    0x4(%eax),%eax
8010508e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105091:	83 c2 1c             	add    $0x1c,%edx
80105094:	83 ec 08             	sub    $0x8,%esp
80105097:	50                   	push   %eax
80105098:	52                   	push   %edx
80105099:	e8 41 0a 00 00       	call   80105adf <swtch>
8010509e:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801050a1:	e8 34 f4 ff ff       	call   801044da <mycpu>
801050a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801050a9:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
801050af:	90                   	nop
801050b0:	c9                   	leave  
801050b1:	c3                   	ret    

801050b2 <yield>:

// Give up the CPU for one scheduling round.
void yield(void)
{
801050b2:	f3 0f 1e fb          	endbr32 
801050b6:	55                   	push   %ebp
801050b7:	89 e5                	mov    %esp,%ebp
801050b9:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock); // DOC: yieldlock
801050bc:	83 ec 0c             	sub    $0xc,%esp
801050bf:	68 c0 5d 11 80       	push   $0x80115dc0
801050c4:	e8 e3 04 00 00       	call   801055ac <acquire>
801050c9:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
801050cc:	e8 85 f4 ff ff       	call   80104556 <myproc>
801050d1:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
801050d8:	e8 18 ff ff ff       	call   80104ff5 <sched>
  release(&ptable.lock);
801050dd:	83 ec 0c             	sub    $0xc,%esp
801050e0:	68 c0 5d 11 80       	push   $0x80115dc0
801050e5:	e8 34 05 00 00       	call   8010561e <release>
801050ea:	83 c4 10             	add    $0x10,%esp
}
801050ed:	90                   	nop
801050ee:	c9                   	leave  
801050ef:	c3                   	ret    

801050f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
801050f0:	f3 0f 1e fb          	endbr32 
801050f4:	55                   	push   %ebp
801050f5:	89 e5                	mov    %esp,%ebp
801050f7:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801050fa:	83 ec 0c             	sub    $0xc,%esp
801050fd:	68 c0 5d 11 80       	push   $0x80115dc0
80105102:	e8 17 05 00 00       	call   8010561e <release>
80105107:	83 c4 10             	add    $0x10,%esp

  if (first)
8010510a:	a1 04 d0 10 80       	mov    0x8010d004,%eax
8010510f:	85 c0                	test   %eax,%eax
80105111:	74 24                	je     80105137 <forkret+0x47>
  {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80105113:	c7 05 04 d0 10 80 00 	movl   $0x0,0x8010d004
8010511a:	00 00 00 
    iinit(ROOTDEV);
8010511d:	83 ec 0c             	sub    $0xc,%esp
80105120:	6a 01                	push   $0x1
80105122:	e8 81 c6 ff ff       	call   801017a8 <iinit>
80105127:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
8010512a:	83 ec 0c             	sub    $0xc,%esp
8010512d:	6a 01                	push   $0x1
8010512f:	e8 96 e3 ff ff       	call   801034ca <initlog>
80105134:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80105137:	90                   	nop
80105138:	c9                   	leave  
80105139:	c3                   	ret    

8010513a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
8010513a:	f3 0f 1e fb          	endbr32 
8010513e:	55                   	push   %ebp
8010513f:	89 e5                	mov    %esp,%ebp
80105141:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
80105144:	e8 0d f4 ff ff       	call   80104556 <myproc>
80105149:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if (p == 0)
8010514c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105150:	75 0d                	jne    8010515f <sleep+0x25>
    panic("sleep");
80105152:	83 ec 0c             	sub    $0xc,%esp
80105155:	68 f7 9b 10 80       	push   $0x80109bf7
8010515a:	e8 a9 b4 ff ff       	call   80100608 <panic>

  if (lk == 0)
8010515f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105163:	75 0d                	jne    80105172 <sleep+0x38>
    panic("sleep without lk");
80105165:	83 ec 0c             	sub    $0xc,%esp
80105168:	68 fd 9b 10 80       	push   $0x80109bfd
8010516d:	e8 96 b4 ff ff       	call   80100608 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if (lk != &ptable.lock)
80105172:	81 7d 0c c0 5d 11 80 	cmpl   $0x80115dc0,0xc(%ebp)
80105179:	74 1e                	je     80105199 <sleep+0x5f>
  {                        // DOC: sleeplock0
    acquire(&ptable.lock); // DOC: sleeplock1
8010517b:	83 ec 0c             	sub    $0xc,%esp
8010517e:	68 c0 5d 11 80       	push   $0x80115dc0
80105183:	e8 24 04 00 00       	call   801055ac <acquire>
80105188:	83 c4 10             	add    $0x10,%esp
    release(lk);
8010518b:	83 ec 0c             	sub    $0xc,%esp
8010518e:	ff 75 0c             	pushl  0xc(%ebp)
80105191:	e8 88 04 00 00       	call   8010561e <release>
80105196:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
80105199:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010519c:	8b 55 08             	mov    0x8(%ebp),%edx
8010519f:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
801051a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051a5:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
801051ac:	e8 44 fe ff ff       	call   80104ff5 <sched>

  // Tidy up.
  p->chan = 0;
801051b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051b4:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if (lk != &ptable.lock)
801051bb:	81 7d 0c c0 5d 11 80 	cmpl   $0x80115dc0,0xc(%ebp)
801051c2:	74 1e                	je     801051e2 <sleep+0xa8>
  { // DOC: sleeplock2
    release(&ptable.lock);
801051c4:	83 ec 0c             	sub    $0xc,%esp
801051c7:	68 c0 5d 11 80       	push   $0x80115dc0
801051cc:	e8 4d 04 00 00       	call   8010561e <release>
801051d1:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
801051d4:	83 ec 0c             	sub    $0xc,%esp
801051d7:	ff 75 0c             	pushl  0xc(%ebp)
801051da:	e8 cd 03 00 00       	call   801055ac <acquire>
801051df:	83 c4 10             	add    $0x10,%esp
  }
}
801051e2:	90                   	nop
801051e3:	c9                   	leave  
801051e4:	c3                   	ret    

801051e5 <wakeup1>:
// PAGEBREAK!
//  Wake up all processes sleeping on chan.
//  The ptable lock must be held.
static void
wakeup1(void *chan)
{
801051e5:	f3 0f 1e fb          	endbr32 
801051e9:	55                   	push   %ebp
801051ea:	89 e5                	mov    %esp,%ebp
801051ec:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801051ef:	c7 45 fc f4 5d 11 80 	movl   $0x80115df4,-0x4(%ebp)
801051f6:	eb 27                	jmp    8010521f <wakeup1+0x3a>
    if (p->state == SLEEPING && p->chan == chan)
801051f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051fb:	8b 40 0c             	mov    0xc(%eax),%eax
801051fe:	83 f8 02             	cmp    $0x2,%eax
80105201:	75 15                	jne    80105218 <wakeup1+0x33>
80105203:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105206:	8b 40 20             	mov    0x20(%eax),%eax
80105209:	39 45 08             	cmp    %eax,0x8(%ebp)
8010520c:	75 0a                	jne    80105218 <wakeup1+0x33>
      p->state = RUNNABLE;
8010520e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105211:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105218:	81 45 fc e4 00 00 00 	addl   $0xe4,-0x4(%ebp)
8010521f:	81 7d fc f4 96 11 80 	cmpl   $0x801196f4,-0x4(%ebp)
80105226:	72 d0                	jb     801051f8 <wakeup1+0x13>
}
80105228:	90                   	nop
80105229:	90                   	nop
8010522a:	c9                   	leave  
8010522b:	c3                   	ret    

8010522c <wakeup>:

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
8010522c:	f3 0f 1e fb          	endbr32 
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80105236:	83 ec 0c             	sub    $0xc,%esp
80105239:	68 c0 5d 11 80       	push   $0x80115dc0
8010523e:	e8 69 03 00 00       	call   801055ac <acquire>
80105243:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80105246:	83 ec 0c             	sub    $0xc,%esp
80105249:	ff 75 08             	pushl  0x8(%ebp)
8010524c:	e8 94 ff ff ff       	call   801051e5 <wakeup1>
80105251:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80105254:	83 ec 0c             	sub    $0xc,%esp
80105257:	68 c0 5d 11 80       	push   $0x80115dc0
8010525c:	e8 bd 03 00 00       	call   8010561e <release>
80105261:	83 c4 10             	add    $0x10,%esp
}
80105264:	90                   	nop
80105265:	c9                   	leave  
80105266:	c3                   	ret    

80105267 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
80105267:	f3 0f 1e fb          	endbr32 
8010526b:	55                   	push   %ebp
8010526c:	89 e5                	mov    %esp,%ebp
8010526e:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80105271:	83 ec 0c             	sub    $0xc,%esp
80105274:	68 c0 5d 11 80       	push   $0x80115dc0
80105279:	e8 2e 03 00 00       	call   801055ac <acquire>
8010527e:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105281:	c7 45 f4 f4 5d 11 80 	movl   $0x80115df4,-0xc(%ebp)
80105288:	eb 48                	jmp    801052d2 <kill+0x6b>
  {
    if (p->pid == pid)
8010528a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010528d:	8b 40 10             	mov    0x10(%eax),%eax
80105290:	39 45 08             	cmp    %eax,0x8(%ebp)
80105293:	75 36                	jne    801052cb <kill+0x64>
    {
      p->killed = 1;
80105295:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105298:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
8010529f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052a2:	8b 40 0c             	mov    0xc(%eax),%eax
801052a5:	83 f8 02             	cmp    $0x2,%eax
801052a8:	75 0a                	jne    801052b4 <kill+0x4d>
        p->state = RUNNABLE;
801052aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052ad:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801052b4:	83 ec 0c             	sub    $0xc,%esp
801052b7:	68 c0 5d 11 80       	push   $0x80115dc0
801052bc:	e8 5d 03 00 00       	call   8010561e <release>
801052c1:	83 c4 10             	add    $0x10,%esp
      return 0;
801052c4:	b8 00 00 00 00       	mov    $0x0,%eax
801052c9:	eb 25                	jmp    801052f0 <kill+0x89>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801052cb:	81 45 f4 e4 00 00 00 	addl   $0xe4,-0xc(%ebp)
801052d2:	81 7d f4 f4 96 11 80 	cmpl   $0x801196f4,-0xc(%ebp)
801052d9:	72 af                	jb     8010528a <kill+0x23>
    }
  }
  release(&ptable.lock);
801052db:	83 ec 0c             	sub    $0xc,%esp
801052de:	68 c0 5d 11 80       	push   $0x80115dc0
801052e3:	e8 36 03 00 00       	call   8010561e <release>
801052e8:	83 c4 10             	add    $0x10,%esp
  return -1;
801052eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052f0:	c9                   	leave  
801052f1:	c3                   	ret    

801052f2 <procdump>:
// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
801052f2:	f3 0f 1e fb          	endbr32 
801052f6:	55                   	push   %ebp
801052f7:	89 e5                	mov    %esp,%ebp
801052f9:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801052fc:	c7 45 f0 f4 5d 11 80 	movl   $0x80115df4,-0x10(%ebp)
80105303:	e9 da 00 00 00       	jmp    801053e2 <procdump+0xf0>
  {
    if (p->state == UNUSED)
80105308:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010530b:	8b 40 0c             	mov    0xc(%eax),%eax
8010530e:	85 c0                	test   %eax,%eax
80105310:	0f 84 c4 00 00 00    	je     801053da <procdump+0xe8>
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105316:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105319:	8b 40 0c             	mov    0xc(%eax),%eax
8010531c:	83 f8 05             	cmp    $0x5,%eax
8010531f:	77 23                	ja     80105344 <procdump+0x52>
80105321:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105324:	8b 40 0c             	mov    0xc(%eax),%eax
80105327:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
8010532e:	85 c0                	test   %eax,%eax
80105330:	74 12                	je     80105344 <procdump+0x52>
      state = states[p->state];
80105332:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105335:	8b 40 0c             	mov    0xc(%eax),%eax
80105338:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
8010533f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105342:	eb 07                	jmp    8010534b <procdump+0x59>
    else
      state = "???";
80105344:	c7 45 ec 0e 9c 10 80 	movl   $0x80109c0e,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
8010534b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010534e:	8d 50 6c             	lea    0x6c(%eax),%edx
80105351:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105354:	8b 40 10             	mov    0x10(%eax),%eax
80105357:	52                   	push   %edx
80105358:	ff 75 ec             	pushl  -0x14(%ebp)
8010535b:	50                   	push   %eax
8010535c:	68 12 9c 10 80       	push   $0x80109c12
80105361:	e8 b2 b0 ff ff       	call   80100418 <cprintf>
80105366:	83 c4 10             	add    $0x10,%esp
    if (p->state == SLEEPING)
80105369:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010536c:	8b 40 0c             	mov    0xc(%eax),%eax
8010536f:	83 f8 02             	cmp    $0x2,%eax
80105372:	75 54                	jne    801053c8 <procdump+0xd6>
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
80105374:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105377:	8b 40 1c             	mov    0x1c(%eax),%eax
8010537a:	8b 40 0c             	mov    0xc(%eax),%eax
8010537d:	83 c0 08             	add    $0x8,%eax
80105380:	89 c2                	mov    %eax,%edx
80105382:	83 ec 08             	sub    $0x8,%esp
80105385:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105388:	50                   	push   %eax
80105389:	52                   	push   %edx
8010538a:	e8 e5 02 00 00       	call   80105674 <getcallerpcs>
8010538f:	83 c4 10             	add    $0x10,%esp
      for (i = 0; i < 10 && pc[i] != 0; i++)
80105392:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105399:	eb 1c                	jmp    801053b7 <procdump+0xc5>
        cprintf(" %p", pc[i]);
8010539b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010539e:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801053a2:	83 ec 08             	sub    $0x8,%esp
801053a5:	50                   	push   %eax
801053a6:	68 1b 9c 10 80       	push   $0x80109c1b
801053ab:	e8 68 b0 ff ff       	call   80100418 <cprintf>
801053b0:	83 c4 10             	add    $0x10,%esp
      for (i = 0; i < 10 && pc[i] != 0; i++)
801053b3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801053b7:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801053bb:	7f 0b                	jg     801053c8 <procdump+0xd6>
801053bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053c0:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801053c4:	85 c0                	test   %eax,%eax
801053c6:	75 d3                	jne    8010539b <procdump+0xa9>
    }
    cprintf("\n");
801053c8:	83 ec 0c             	sub    $0xc,%esp
801053cb:	68 1f 9c 10 80       	push   $0x80109c1f
801053d0:	e8 43 b0 ff ff       	call   80100418 <cprintf>
801053d5:	83 c4 10             	add    $0x10,%esp
801053d8:	eb 01                	jmp    801053db <procdump+0xe9>
      continue;
801053da:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801053db:	81 45 f0 e4 00 00 00 	addl   $0xe4,-0x10(%ebp)
801053e2:	81 7d f0 f4 96 11 80 	cmpl   $0x801196f4,-0x10(%ebp)
801053e9:	0f 82 19 ff ff ff    	jb     80105308 <procdump+0x16>
  }
}
801053ef:	90                   	nop
801053f0:	90                   	nop
801053f1:	c9                   	leave  
801053f2:	c3                   	ret    

801053f3 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801053f3:	f3 0f 1e fb          	endbr32 
801053f7:	55                   	push   %ebp
801053f8:	89 e5                	mov    %esp,%ebp
801053fa:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
801053fd:	8b 45 08             	mov    0x8(%ebp),%eax
80105400:	83 c0 04             	add    $0x4,%eax
80105403:	83 ec 08             	sub    $0x8,%esp
80105406:	68 4b 9c 10 80       	push   $0x80109c4b
8010540b:	50                   	push   %eax
8010540c:	e8 75 01 00 00       	call   80105586 <initlock>
80105411:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
80105414:	8b 45 08             	mov    0x8(%ebp),%eax
80105417:	8b 55 0c             	mov    0xc(%ebp),%edx
8010541a:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
8010541d:	8b 45 08             	mov    0x8(%ebp),%eax
80105420:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80105426:	8b 45 08             	mov    0x8(%ebp),%eax
80105429:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80105430:	90                   	nop
80105431:	c9                   	leave  
80105432:	c3                   	ret    

80105433 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105433:	f3 0f 1e fb          	endbr32 
80105437:	55                   	push   %ebp
80105438:	89 e5                	mov    %esp,%ebp
8010543a:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
8010543d:	8b 45 08             	mov    0x8(%ebp),%eax
80105440:	83 c0 04             	add    $0x4,%eax
80105443:	83 ec 0c             	sub    $0xc,%esp
80105446:	50                   	push   %eax
80105447:	e8 60 01 00 00       	call   801055ac <acquire>
8010544c:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
8010544f:	eb 15                	jmp    80105466 <acquiresleep+0x33>
    sleep(lk, &lk->lk);
80105451:	8b 45 08             	mov    0x8(%ebp),%eax
80105454:	83 c0 04             	add    $0x4,%eax
80105457:	83 ec 08             	sub    $0x8,%esp
8010545a:	50                   	push   %eax
8010545b:	ff 75 08             	pushl  0x8(%ebp)
8010545e:	e8 d7 fc ff ff       	call   8010513a <sleep>
80105463:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80105466:	8b 45 08             	mov    0x8(%ebp),%eax
80105469:	8b 00                	mov    (%eax),%eax
8010546b:	85 c0                	test   %eax,%eax
8010546d:	75 e2                	jne    80105451 <acquiresleep+0x1e>
  }
  lk->locked = 1;
8010546f:	8b 45 08             	mov    0x8(%ebp),%eax
80105472:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
80105478:	e8 d9 f0 ff ff       	call   80104556 <myproc>
8010547d:	8b 50 10             	mov    0x10(%eax),%edx
80105480:	8b 45 08             	mov    0x8(%ebp),%eax
80105483:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80105486:	8b 45 08             	mov    0x8(%ebp),%eax
80105489:	83 c0 04             	add    $0x4,%eax
8010548c:	83 ec 0c             	sub    $0xc,%esp
8010548f:	50                   	push   %eax
80105490:	e8 89 01 00 00       	call   8010561e <release>
80105495:	83 c4 10             	add    $0x10,%esp
}
80105498:	90                   	nop
80105499:	c9                   	leave  
8010549a:	c3                   	ret    

8010549b <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
8010549b:	f3 0f 1e fb          	endbr32 
8010549f:	55                   	push   %ebp
801054a0:	89 e5                	mov    %esp,%ebp
801054a2:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
801054a5:	8b 45 08             	mov    0x8(%ebp),%eax
801054a8:	83 c0 04             	add    $0x4,%eax
801054ab:	83 ec 0c             	sub    $0xc,%esp
801054ae:	50                   	push   %eax
801054af:	e8 f8 00 00 00       	call   801055ac <acquire>
801054b4:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
801054b7:	8b 45 08             	mov    0x8(%ebp),%eax
801054ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
801054c0:	8b 45 08             	mov    0x8(%ebp),%eax
801054c3:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
801054ca:	83 ec 0c             	sub    $0xc,%esp
801054cd:	ff 75 08             	pushl  0x8(%ebp)
801054d0:	e8 57 fd ff ff       	call   8010522c <wakeup>
801054d5:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
801054d8:	8b 45 08             	mov    0x8(%ebp),%eax
801054db:	83 c0 04             	add    $0x4,%eax
801054de:	83 ec 0c             	sub    $0xc,%esp
801054e1:	50                   	push   %eax
801054e2:	e8 37 01 00 00       	call   8010561e <release>
801054e7:	83 c4 10             	add    $0x10,%esp
}
801054ea:	90                   	nop
801054eb:	c9                   	leave  
801054ec:	c3                   	ret    

801054ed <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801054ed:	f3 0f 1e fb          	endbr32 
801054f1:	55                   	push   %ebp
801054f2:	89 e5                	mov    %esp,%ebp
801054f4:	53                   	push   %ebx
801054f5:	83 ec 14             	sub    $0x14,%esp
  int r;
  
  acquire(&lk->lk);
801054f8:	8b 45 08             	mov    0x8(%ebp),%eax
801054fb:	83 c0 04             	add    $0x4,%eax
801054fe:	83 ec 0c             	sub    $0xc,%esp
80105501:	50                   	push   %eax
80105502:	e8 a5 00 00 00       	call   801055ac <acquire>
80105507:	83 c4 10             	add    $0x10,%esp
  r = lk->locked && (lk->pid == myproc()->pid);
8010550a:	8b 45 08             	mov    0x8(%ebp),%eax
8010550d:	8b 00                	mov    (%eax),%eax
8010550f:	85 c0                	test   %eax,%eax
80105511:	74 19                	je     8010552c <holdingsleep+0x3f>
80105513:	8b 45 08             	mov    0x8(%ebp),%eax
80105516:	8b 58 3c             	mov    0x3c(%eax),%ebx
80105519:	e8 38 f0 ff ff       	call   80104556 <myproc>
8010551e:	8b 40 10             	mov    0x10(%eax),%eax
80105521:	39 c3                	cmp    %eax,%ebx
80105523:	75 07                	jne    8010552c <holdingsleep+0x3f>
80105525:	b8 01 00 00 00       	mov    $0x1,%eax
8010552a:	eb 05                	jmp    80105531 <holdingsleep+0x44>
8010552c:	b8 00 00 00 00       	mov    $0x0,%eax
80105531:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80105534:	8b 45 08             	mov    0x8(%ebp),%eax
80105537:	83 c0 04             	add    $0x4,%eax
8010553a:	83 ec 0c             	sub    $0xc,%esp
8010553d:	50                   	push   %eax
8010553e:	e8 db 00 00 00       	call   8010561e <release>
80105543:	83 c4 10             	add    $0x10,%esp
  return r;
80105546:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105549:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010554c:	c9                   	leave  
8010554d:	c3                   	ret    

8010554e <readeflags>:
{
8010554e:	55                   	push   %ebp
8010554f:	89 e5                	mov    %esp,%ebp
80105551:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105554:	9c                   	pushf  
80105555:	58                   	pop    %eax
80105556:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105559:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010555c:	c9                   	leave  
8010555d:	c3                   	ret    

8010555e <cli>:
{
8010555e:	55                   	push   %ebp
8010555f:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105561:	fa                   	cli    
}
80105562:	90                   	nop
80105563:	5d                   	pop    %ebp
80105564:	c3                   	ret    

80105565 <sti>:
{
80105565:	55                   	push   %ebp
80105566:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105568:	fb                   	sti    
}
80105569:	90                   	nop
8010556a:	5d                   	pop    %ebp
8010556b:	c3                   	ret    

8010556c <xchg>:
{
8010556c:	55                   	push   %ebp
8010556d:	89 e5                	mov    %esp,%ebp
8010556f:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
80105572:	8b 55 08             	mov    0x8(%ebp),%edx
80105575:	8b 45 0c             	mov    0xc(%ebp),%eax
80105578:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010557b:	f0 87 02             	lock xchg %eax,(%edx)
8010557e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
80105581:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105584:	c9                   	leave  
80105585:	c3                   	ret    

80105586 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105586:	f3 0f 1e fb          	endbr32 
8010558a:	55                   	push   %ebp
8010558b:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010558d:	8b 45 08             	mov    0x8(%ebp),%eax
80105590:	8b 55 0c             	mov    0xc(%ebp),%edx
80105593:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105596:	8b 45 08             	mov    0x8(%ebp),%eax
80105599:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
8010559f:	8b 45 08             	mov    0x8(%ebp),%eax
801055a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801055a9:	90                   	nop
801055aa:	5d                   	pop    %ebp
801055ab:	c3                   	ret    

801055ac <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801055ac:	f3 0f 1e fb          	endbr32 
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	53                   	push   %ebx
801055b4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801055b7:	e8 7c 01 00 00       	call   80105738 <pushcli>
  if(holding(lk))
801055bc:	8b 45 08             	mov    0x8(%ebp),%eax
801055bf:	83 ec 0c             	sub    $0xc,%esp
801055c2:	50                   	push   %eax
801055c3:	e8 2b 01 00 00       	call   801056f3 <holding>
801055c8:	83 c4 10             	add    $0x10,%esp
801055cb:	85 c0                	test   %eax,%eax
801055cd:	74 0d                	je     801055dc <acquire+0x30>
    panic("acquire");
801055cf:	83 ec 0c             	sub    $0xc,%esp
801055d2:	68 56 9c 10 80       	push   $0x80109c56
801055d7:	e8 2c b0 ff ff       	call   80100608 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801055dc:	90                   	nop
801055dd:	8b 45 08             	mov    0x8(%ebp),%eax
801055e0:	83 ec 08             	sub    $0x8,%esp
801055e3:	6a 01                	push   $0x1
801055e5:	50                   	push   %eax
801055e6:	e8 81 ff ff ff       	call   8010556c <xchg>
801055eb:	83 c4 10             	add    $0x10,%esp
801055ee:	85 c0                	test   %eax,%eax
801055f0:	75 eb                	jne    801055dd <acquire+0x31>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801055f2:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801055f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801055fa:	e8 db ee ff ff       	call   801044da <mycpu>
801055ff:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80105602:	8b 45 08             	mov    0x8(%ebp),%eax
80105605:	83 c0 0c             	add    $0xc,%eax
80105608:	83 ec 08             	sub    $0x8,%esp
8010560b:	50                   	push   %eax
8010560c:	8d 45 08             	lea    0x8(%ebp),%eax
8010560f:	50                   	push   %eax
80105610:	e8 5f 00 00 00       	call   80105674 <getcallerpcs>
80105615:	83 c4 10             	add    $0x10,%esp
}
80105618:	90                   	nop
80105619:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010561c:	c9                   	leave  
8010561d:	c3                   	ret    

8010561e <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
8010561e:	f3 0f 1e fb          	endbr32 
80105622:	55                   	push   %ebp
80105623:	89 e5                	mov    %esp,%ebp
80105625:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80105628:	83 ec 0c             	sub    $0xc,%esp
8010562b:	ff 75 08             	pushl  0x8(%ebp)
8010562e:	e8 c0 00 00 00       	call   801056f3 <holding>
80105633:	83 c4 10             	add    $0x10,%esp
80105636:	85 c0                	test   %eax,%eax
80105638:	75 0d                	jne    80105647 <release+0x29>
    panic("release");
8010563a:	83 ec 0c             	sub    $0xc,%esp
8010563d:	68 5e 9c 10 80       	push   $0x80109c5e
80105642:	e8 c1 af ff ff       	call   80100608 <panic>

  lk->pcs[0] = 0;
80105647:	8b 45 08             	mov    0x8(%ebp),%eax
8010564a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105651:	8b 45 08             	mov    0x8(%ebp),%eax
80105654:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
8010565b:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80105660:	8b 45 08             	mov    0x8(%ebp),%eax
80105663:	8b 55 08             	mov    0x8(%ebp),%edx
80105666:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
8010566c:	e8 18 01 00 00       	call   80105789 <popcli>
}
80105671:	90                   	nop
80105672:	c9                   	leave  
80105673:	c3                   	ret    

80105674 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105674:	f3 0f 1e fb          	endbr32 
80105678:	55                   	push   %ebp
80105679:	89 e5                	mov    %esp,%ebp
8010567b:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010567e:	8b 45 08             	mov    0x8(%ebp),%eax
80105681:	83 e8 08             	sub    $0x8,%eax
80105684:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105687:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010568e:	eb 38                	jmp    801056c8 <getcallerpcs+0x54>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105690:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105694:	74 53                	je     801056e9 <getcallerpcs+0x75>
80105696:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010569d:	76 4a                	jbe    801056e9 <getcallerpcs+0x75>
8010569f:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801056a3:	74 44                	je     801056e9 <getcallerpcs+0x75>
      break;
    pcs[i] = ebp[1];     // saved %eip
801056a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801056a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801056af:	8b 45 0c             	mov    0xc(%ebp),%eax
801056b2:	01 c2                	add    %eax,%edx
801056b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056b7:	8b 40 04             	mov    0x4(%eax),%eax
801056ba:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801056bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056bf:	8b 00                	mov    (%eax),%eax
801056c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801056c4:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801056c8:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801056cc:	7e c2                	jle    80105690 <getcallerpcs+0x1c>
  }
  for(; i < 10; i++)
801056ce:	eb 19                	jmp    801056e9 <getcallerpcs+0x75>
    pcs[i] = 0;
801056d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
801056d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801056da:	8b 45 0c             	mov    0xc(%ebp),%eax
801056dd:	01 d0                	add    %edx,%eax
801056df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801056e5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801056e9:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801056ed:	7e e1                	jle    801056d0 <getcallerpcs+0x5c>
}
801056ef:	90                   	nop
801056f0:	90                   	nop
801056f1:	c9                   	leave  
801056f2:	c3                   	ret    

801056f3 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801056f3:	f3 0f 1e fb          	endbr32 
801056f7:	55                   	push   %ebp
801056f8:	89 e5                	mov    %esp,%ebp
801056fa:	53                   	push   %ebx
801056fb:	83 ec 14             	sub    $0x14,%esp
  int r;
  pushcli();
801056fe:	e8 35 00 00 00       	call   80105738 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105703:	8b 45 08             	mov    0x8(%ebp),%eax
80105706:	8b 00                	mov    (%eax),%eax
80105708:	85 c0                	test   %eax,%eax
8010570a:	74 16                	je     80105722 <holding+0x2f>
8010570c:	8b 45 08             	mov    0x8(%ebp),%eax
8010570f:	8b 58 08             	mov    0x8(%eax),%ebx
80105712:	e8 c3 ed ff ff       	call   801044da <mycpu>
80105717:	39 c3                	cmp    %eax,%ebx
80105719:	75 07                	jne    80105722 <holding+0x2f>
8010571b:	b8 01 00 00 00       	mov    $0x1,%eax
80105720:	eb 05                	jmp    80105727 <holding+0x34>
80105722:	b8 00 00 00 00       	mov    $0x0,%eax
80105727:	89 45 f4             	mov    %eax,-0xc(%ebp)
  popcli();
8010572a:	e8 5a 00 00 00       	call   80105789 <popcli>
  return r;
8010572f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105732:	83 c4 14             	add    $0x14,%esp
80105735:	5b                   	pop    %ebx
80105736:	5d                   	pop    %ebp
80105737:	c3                   	ret    

80105738 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105738:	f3 0f 1e fb          	endbr32 
8010573c:	55                   	push   %ebp
8010573d:	89 e5                	mov    %esp,%ebp
8010573f:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80105742:	e8 07 fe ff ff       	call   8010554e <readeflags>
80105747:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
8010574a:	e8 0f fe ff ff       	call   8010555e <cli>
  if(mycpu()->ncli == 0)
8010574f:	e8 86 ed ff ff       	call   801044da <mycpu>
80105754:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010575a:	85 c0                	test   %eax,%eax
8010575c:	75 14                	jne    80105772 <pushcli+0x3a>
    mycpu()->intena = eflags & FL_IF;
8010575e:	e8 77 ed ff ff       	call   801044da <mycpu>
80105763:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105766:	81 e2 00 02 00 00    	and    $0x200,%edx
8010576c:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80105772:	e8 63 ed ff ff       	call   801044da <mycpu>
80105777:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010577d:	83 c2 01             	add    $0x1,%edx
80105780:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80105786:	90                   	nop
80105787:	c9                   	leave  
80105788:	c3                   	ret    

80105789 <popcli>:

void
popcli(void)
{
80105789:	f3 0f 1e fb          	endbr32 
8010578d:	55                   	push   %ebp
8010578e:	89 e5                	mov    %esp,%ebp
80105790:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105793:	e8 b6 fd ff ff       	call   8010554e <readeflags>
80105798:	25 00 02 00 00       	and    $0x200,%eax
8010579d:	85 c0                	test   %eax,%eax
8010579f:	74 0d                	je     801057ae <popcli+0x25>
    panic("popcli - interruptible");
801057a1:	83 ec 0c             	sub    $0xc,%esp
801057a4:	68 66 9c 10 80       	push   $0x80109c66
801057a9:	e8 5a ae ff ff       	call   80100608 <panic>
  if(--mycpu()->ncli < 0)
801057ae:	e8 27 ed ff ff       	call   801044da <mycpu>
801057b3:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801057b9:	83 ea 01             	sub    $0x1,%edx
801057bc:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801057c2:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801057c8:	85 c0                	test   %eax,%eax
801057ca:	79 0d                	jns    801057d9 <popcli+0x50>
    panic("popcli");
801057cc:	83 ec 0c             	sub    $0xc,%esp
801057cf:	68 7d 9c 10 80       	push   $0x80109c7d
801057d4:	e8 2f ae ff ff       	call   80100608 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
801057d9:	e8 fc ec ff ff       	call   801044da <mycpu>
801057de:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801057e4:	85 c0                	test   %eax,%eax
801057e6:	75 14                	jne    801057fc <popcli+0x73>
801057e8:	e8 ed ec ff ff       	call   801044da <mycpu>
801057ed:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801057f3:	85 c0                	test   %eax,%eax
801057f5:	74 05                	je     801057fc <popcli+0x73>
    sti();
801057f7:	e8 69 fd ff ff       	call   80105565 <sti>
}
801057fc:	90                   	nop
801057fd:	c9                   	leave  
801057fe:	c3                   	ret    

801057ff <stosb>:
{
801057ff:	55                   	push   %ebp
80105800:	89 e5                	mov    %esp,%ebp
80105802:	57                   	push   %edi
80105803:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105804:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105807:	8b 55 10             	mov    0x10(%ebp),%edx
8010580a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010580d:	89 cb                	mov    %ecx,%ebx
8010580f:	89 df                	mov    %ebx,%edi
80105811:	89 d1                	mov    %edx,%ecx
80105813:	fc                   	cld    
80105814:	f3 aa                	rep stos %al,%es:(%edi)
80105816:	89 ca                	mov    %ecx,%edx
80105818:	89 fb                	mov    %edi,%ebx
8010581a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010581d:	89 55 10             	mov    %edx,0x10(%ebp)
}
80105820:	90                   	nop
80105821:	5b                   	pop    %ebx
80105822:	5f                   	pop    %edi
80105823:	5d                   	pop    %ebp
80105824:	c3                   	ret    

80105825 <stosl>:
{
80105825:	55                   	push   %ebp
80105826:	89 e5                	mov    %esp,%ebp
80105828:	57                   	push   %edi
80105829:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
8010582a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010582d:	8b 55 10             	mov    0x10(%ebp),%edx
80105830:	8b 45 0c             	mov    0xc(%ebp),%eax
80105833:	89 cb                	mov    %ecx,%ebx
80105835:	89 df                	mov    %ebx,%edi
80105837:	89 d1                	mov    %edx,%ecx
80105839:	fc                   	cld    
8010583a:	f3 ab                	rep stos %eax,%es:(%edi)
8010583c:	89 ca                	mov    %ecx,%edx
8010583e:	89 fb                	mov    %edi,%ebx
80105840:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105843:	89 55 10             	mov    %edx,0x10(%ebp)
}
80105846:	90                   	nop
80105847:	5b                   	pop    %ebx
80105848:	5f                   	pop    %edi
80105849:	5d                   	pop    %ebp
8010584a:	c3                   	ret    

8010584b <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010584b:	f3 0f 1e fb          	endbr32 
8010584f:	55                   	push   %ebp
80105850:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105852:	8b 45 08             	mov    0x8(%ebp),%eax
80105855:	83 e0 03             	and    $0x3,%eax
80105858:	85 c0                	test   %eax,%eax
8010585a:	75 43                	jne    8010589f <memset+0x54>
8010585c:	8b 45 10             	mov    0x10(%ebp),%eax
8010585f:	83 e0 03             	and    $0x3,%eax
80105862:	85 c0                	test   %eax,%eax
80105864:	75 39                	jne    8010589f <memset+0x54>
    c &= 0xFF;
80105866:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010586d:	8b 45 10             	mov    0x10(%ebp),%eax
80105870:	c1 e8 02             	shr    $0x2,%eax
80105873:	89 c1                	mov    %eax,%ecx
80105875:	8b 45 0c             	mov    0xc(%ebp),%eax
80105878:	c1 e0 18             	shl    $0x18,%eax
8010587b:	89 c2                	mov    %eax,%edx
8010587d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105880:	c1 e0 10             	shl    $0x10,%eax
80105883:	09 c2                	or     %eax,%edx
80105885:	8b 45 0c             	mov    0xc(%ebp),%eax
80105888:	c1 e0 08             	shl    $0x8,%eax
8010588b:	09 d0                	or     %edx,%eax
8010588d:	0b 45 0c             	or     0xc(%ebp),%eax
80105890:	51                   	push   %ecx
80105891:	50                   	push   %eax
80105892:	ff 75 08             	pushl  0x8(%ebp)
80105895:	e8 8b ff ff ff       	call   80105825 <stosl>
8010589a:	83 c4 0c             	add    $0xc,%esp
8010589d:	eb 12                	jmp    801058b1 <memset+0x66>
  } else
    stosb(dst, c, n);
8010589f:	8b 45 10             	mov    0x10(%ebp),%eax
801058a2:	50                   	push   %eax
801058a3:	ff 75 0c             	pushl  0xc(%ebp)
801058a6:	ff 75 08             	pushl  0x8(%ebp)
801058a9:	e8 51 ff ff ff       	call   801057ff <stosb>
801058ae:	83 c4 0c             	add    $0xc,%esp
  return dst;
801058b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
801058b4:	c9                   	leave  
801058b5:	c3                   	ret    

801058b6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801058b6:	f3 0f 1e fb          	endbr32 
801058ba:	55                   	push   %ebp
801058bb:	89 e5                	mov    %esp,%ebp
801058bd:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
801058c0:	8b 45 08             	mov    0x8(%ebp),%eax
801058c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801058c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801058c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801058cc:	eb 30                	jmp    801058fe <memcmp+0x48>
    if(*s1 != *s2)
801058ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058d1:	0f b6 10             	movzbl (%eax),%edx
801058d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
801058d7:	0f b6 00             	movzbl (%eax),%eax
801058da:	38 c2                	cmp    %al,%dl
801058dc:	74 18                	je     801058f6 <memcmp+0x40>
      return *s1 - *s2;
801058de:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058e1:	0f b6 00             	movzbl (%eax),%eax
801058e4:	0f b6 d0             	movzbl %al,%edx
801058e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
801058ea:	0f b6 00             	movzbl (%eax),%eax
801058ed:	0f b6 c0             	movzbl %al,%eax
801058f0:	29 c2                	sub    %eax,%edx
801058f2:	89 d0                	mov    %edx,%eax
801058f4:	eb 1a                	jmp    80105910 <memcmp+0x5a>
    s1++, s2++;
801058f6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801058fa:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
801058fe:	8b 45 10             	mov    0x10(%ebp),%eax
80105901:	8d 50 ff             	lea    -0x1(%eax),%edx
80105904:	89 55 10             	mov    %edx,0x10(%ebp)
80105907:	85 c0                	test   %eax,%eax
80105909:	75 c3                	jne    801058ce <memcmp+0x18>
  }

  return 0;
8010590b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105910:	c9                   	leave  
80105911:	c3                   	ret    

80105912 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105912:	f3 0f 1e fb          	endbr32 
80105916:	55                   	push   %ebp
80105917:	89 e5                	mov    %esp,%ebp
80105919:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
8010591c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010591f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105922:	8b 45 08             	mov    0x8(%ebp),%eax
80105925:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105928:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010592b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010592e:	73 54                	jae    80105984 <memmove+0x72>
80105930:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105933:	8b 45 10             	mov    0x10(%ebp),%eax
80105936:	01 d0                	add    %edx,%eax
80105938:	39 45 f8             	cmp    %eax,-0x8(%ebp)
8010593b:	73 47                	jae    80105984 <memmove+0x72>
    s += n;
8010593d:	8b 45 10             	mov    0x10(%ebp),%eax
80105940:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105943:	8b 45 10             	mov    0x10(%ebp),%eax
80105946:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105949:	eb 13                	jmp    8010595e <memmove+0x4c>
      *--d = *--s;
8010594b:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010594f:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105953:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105956:	0f b6 10             	movzbl (%eax),%edx
80105959:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010595c:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
8010595e:	8b 45 10             	mov    0x10(%ebp),%eax
80105961:	8d 50 ff             	lea    -0x1(%eax),%edx
80105964:	89 55 10             	mov    %edx,0x10(%ebp)
80105967:	85 c0                	test   %eax,%eax
80105969:	75 e0                	jne    8010594b <memmove+0x39>
  if(s < d && s + n > d){
8010596b:	eb 24                	jmp    80105991 <memmove+0x7f>
  } else
    while(n-- > 0)
      *d++ = *s++;
8010596d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105970:	8d 42 01             	lea    0x1(%edx),%eax
80105973:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105976:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105979:	8d 48 01             	lea    0x1(%eax),%ecx
8010597c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
8010597f:	0f b6 12             	movzbl (%edx),%edx
80105982:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80105984:	8b 45 10             	mov    0x10(%ebp),%eax
80105987:	8d 50 ff             	lea    -0x1(%eax),%edx
8010598a:	89 55 10             	mov    %edx,0x10(%ebp)
8010598d:	85 c0                	test   %eax,%eax
8010598f:	75 dc                	jne    8010596d <memmove+0x5b>

  return dst;
80105991:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105994:	c9                   	leave  
80105995:	c3                   	ret    

80105996 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105996:	f3 0f 1e fb          	endbr32 
8010599a:	55                   	push   %ebp
8010599b:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
8010599d:	ff 75 10             	pushl  0x10(%ebp)
801059a0:	ff 75 0c             	pushl  0xc(%ebp)
801059a3:	ff 75 08             	pushl  0x8(%ebp)
801059a6:	e8 67 ff ff ff       	call   80105912 <memmove>
801059ab:	83 c4 0c             	add    $0xc,%esp
}
801059ae:	c9                   	leave  
801059af:	c3                   	ret    

801059b0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801059b0:	f3 0f 1e fb          	endbr32 
801059b4:	55                   	push   %ebp
801059b5:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801059b7:	eb 0c                	jmp    801059c5 <strncmp+0x15>
    n--, p++, q++;
801059b9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801059bd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801059c1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
801059c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059c9:	74 1a                	je     801059e5 <strncmp+0x35>
801059cb:	8b 45 08             	mov    0x8(%ebp),%eax
801059ce:	0f b6 00             	movzbl (%eax),%eax
801059d1:	84 c0                	test   %al,%al
801059d3:	74 10                	je     801059e5 <strncmp+0x35>
801059d5:	8b 45 08             	mov    0x8(%ebp),%eax
801059d8:	0f b6 10             	movzbl (%eax),%edx
801059db:	8b 45 0c             	mov    0xc(%ebp),%eax
801059de:	0f b6 00             	movzbl (%eax),%eax
801059e1:	38 c2                	cmp    %al,%dl
801059e3:	74 d4                	je     801059b9 <strncmp+0x9>
  if(n == 0)
801059e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059e9:	75 07                	jne    801059f2 <strncmp+0x42>
    return 0;
801059eb:	b8 00 00 00 00       	mov    $0x0,%eax
801059f0:	eb 16                	jmp    80105a08 <strncmp+0x58>
  return (uchar)*p - (uchar)*q;
801059f2:	8b 45 08             	mov    0x8(%ebp),%eax
801059f5:	0f b6 00             	movzbl (%eax),%eax
801059f8:	0f b6 d0             	movzbl %al,%edx
801059fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801059fe:	0f b6 00             	movzbl (%eax),%eax
80105a01:	0f b6 c0             	movzbl %al,%eax
80105a04:	29 c2                	sub    %eax,%edx
80105a06:	89 d0                	mov    %edx,%eax
}
80105a08:	5d                   	pop    %ebp
80105a09:	c3                   	ret    

80105a0a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105a0a:	f3 0f 1e fb          	endbr32 
80105a0e:	55                   	push   %ebp
80105a0f:	89 e5                	mov    %esp,%ebp
80105a11:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105a14:	8b 45 08             	mov    0x8(%ebp),%eax
80105a17:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105a1a:	90                   	nop
80105a1b:	8b 45 10             	mov    0x10(%ebp),%eax
80105a1e:	8d 50 ff             	lea    -0x1(%eax),%edx
80105a21:	89 55 10             	mov    %edx,0x10(%ebp)
80105a24:	85 c0                	test   %eax,%eax
80105a26:	7e 2c                	jle    80105a54 <strncpy+0x4a>
80105a28:	8b 55 0c             	mov    0xc(%ebp),%edx
80105a2b:	8d 42 01             	lea    0x1(%edx),%eax
80105a2e:	89 45 0c             	mov    %eax,0xc(%ebp)
80105a31:	8b 45 08             	mov    0x8(%ebp),%eax
80105a34:	8d 48 01             	lea    0x1(%eax),%ecx
80105a37:	89 4d 08             	mov    %ecx,0x8(%ebp)
80105a3a:	0f b6 12             	movzbl (%edx),%edx
80105a3d:	88 10                	mov    %dl,(%eax)
80105a3f:	0f b6 00             	movzbl (%eax),%eax
80105a42:	84 c0                	test   %al,%al
80105a44:	75 d5                	jne    80105a1b <strncpy+0x11>
    ;
  while(n-- > 0)
80105a46:	eb 0c                	jmp    80105a54 <strncpy+0x4a>
    *s++ = 0;
80105a48:	8b 45 08             	mov    0x8(%ebp),%eax
80105a4b:	8d 50 01             	lea    0x1(%eax),%edx
80105a4e:	89 55 08             	mov    %edx,0x8(%ebp)
80105a51:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
80105a54:	8b 45 10             	mov    0x10(%ebp),%eax
80105a57:	8d 50 ff             	lea    -0x1(%eax),%edx
80105a5a:	89 55 10             	mov    %edx,0x10(%ebp)
80105a5d:	85 c0                	test   %eax,%eax
80105a5f:	7f e7                	jg     80105a48 <strncpy+0x3e>
  return os;
80105a61:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a64:	c9                   	leave  
80105a65:	c3                   	ret    

80105a66 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105a66:	f3 0f 1e fb          	endbr32 
80105a6a:	55                   	push   %ebp
80105a6b:	89 e5                	mov    %esp,%ebp
80105a6d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105a70:	8b 45 08             	mov    0x8(%ebp),%eax
80105a73:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105a76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a7a:	7f 05                	jg     80105a81 <safestrcpy+0x1b>
    return os;
80105a7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a7f:	eb 31                	jmp    80105ab2 <safestrcpy+0x4c>
  while(--n > 0 && (*s++ = *t++) != 0)
80105a81:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105a85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a89:	7e 1e                	jle    80105aa9 <safestrcpy+0x43>
80105a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
80105a8e:	8d 42 01             	lea    0x1(%edx),%eax
80105a91:	89 45 0c             	mov    %eax,0xc(%ebp)
80105a94:	8b 45 08             	mov    0x8(%ebp),%eax
80105a97:	8d 48 01             	lea    0x1(%eax),%ecx
80105a9a:	89 4d 08             	mov    %ecx,0x8(%ebp)
80105a9d:	0f b6 12             	movzbl (%edx),%edx
80105aa0:	88 10                	mov    %dl,(%eax)
80105aa2:	0f b6 00             	movzbl (%eax),%eax
80105aa5:	84 c0                	test   %al,%al
80105aa7:	75 d8                	jne    80105a81 <safestrcpy+0x1b>
    ;
  *s = 0;
80105aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80105aac:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105aaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105ab2:	c9                   	leave  
80105ab3:	c3                   	ret    

80105ab4 <strlen>:

int
strlen(const char *s)
{
80105ab4:	f3 0f 1e fb          	endbr32 
80105ab8:	55                   	push   %ebp
80105ab9:	89 e5                	mov    %esp,%ebp
80105abb:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105abe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105ac5:	eb 04                	jmp    80105acb <strlen+0x17>
80105ac7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105acb:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105ace:	8b 45 08             	mov    0x8(%ebp),%eax
80105ad1:	01 d0                	add    %edx,%eax
80105ad3:	0f b6 00             	movzbl (%eax),%eax
80105ad6:	84 c0                	test   %al,%al
80105ad8:	75 ed                	jne    80105ac7 <strlen+0x13>
    ;
  return n;
80105ada:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105add:	c9                   	leave  
80105ade:	c3                   	ret    

80105adf <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105adf:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105ae3:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105ae7:	55                   	push   %ebp
  pushl %ebx
80105ae8:	53                   	push   %ebx
  pushl %esi
80105ae9:	56                   	push   %esi
  pushl %edi
80105aea:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105aeb:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105aed:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105aef:	5f                   	pop    %edi
  popl %esi
80105af0:	5e                   	pop    %esi
  popl %ebx
80105af1:	5b                   	pop    %ebx
  popl %ebp
80105af2:	5d                   	pop    %ebp
  ret
80105af3:	c3                   	ret    

80105af4 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105af4:	f3 0f 1e fb          	endbr32 
80105af8:	55                   	push   %ebp
80105af9:	89 e5                	mov    %esp,%ebp
80105afb:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80105afe:	e8 53 ea ff ff       	call   80104556 <myproc>
80105b03:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b09:	8b 00                	mov    (%eax),%eax
80105b0b:	39 45 08             	cmp    %eax,0x8(%ebp)
80105b0e:	73 0f                	jae    80105b1f <fetchint+0x2b>
80105b10:	8b 45 08             	mov    0x8(%ebp),%eax
80105b13:	8d 50 04             	lea    0x4(%eax),%edx
80105b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b19:	8b 00                	mov    (%eax),%eax
80105b1b:	39 c2                	cmp    %eax,%edx
80105b1d:	76 07                	jbe    80105b26 <fetchint+0x32>
    return -1;
80105b1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b24:	eb 0f                	jmp    80105b35 <fetchint+0x41>
  *ip = *(int*)(addr);
80105b26:	8b 45 08             	mov    0x8(%ebp),%eax
80105b29:	8b 10                	mov    (%eax),%edx
80105b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b2e:	89 10                	mov    %edx,(%eax)
  return 0;
80105b30:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b35:	c9                   	leave  
80105b36:	c3                   	ret    

80105b37 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105b37:	f3 0f 1e fb          	endbr32 
80105b3b:	55                   	push   %ebp
80105b3c:	89 e5                	mov    %esp,%ebp
80105b3e:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
80105b41:	e8 10 ea ff ff       	call   80104556 <myproc>
80105b46:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
80105b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b4c:	8b 00                	mov    (%eax),%eax
80105b4e:	39 45 08             	cmp    %eax,0x8(%ebp)
80105b51:	72 07                	jb     80105b5a <fetchstr+0x23>
    return -1;
80105b53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b58:	eb 43                	jmp    80105b9d <fetchstr+0x66>
  *pp = (char*)addr;
80105b5a:	8b 55 08             	mov    0x8(%ebp),%edx
80105b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b60:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
80105b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b65:	8b 00                	mov    (%eax),%eax
80105b67:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
80105b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b6d:	8b 00                	mov    (%eax),%eax
80105b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b72:	eb 1c                	jmp    80105b90 <fetchstr+0x59>
    if(*s == 0)
80105b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b77:	0f b6 00             	movzbl (%eax),%eax
80105b7a:	84 c0                	test   %al,%al
80105b7c:	75 0e                	jne    80105b8c <fetchstr+0x55>
      return s - *pp;
80105b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b81:	8b 00                	mov    (%eax),%eax
80105b83:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b86:	29 c2                	sub    %eax,%edx
80105b88:	89 d0                	mov    %edx,%eax
80105b8a:	eb 11                	jmp    80105b9d <fetchstr+0x66>
  for(s = *pp; s < ep; s++){
80105b8c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b93:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80105b96:	72 dc                	jb     80105b74 <fetchstr+0x3d>
  }
  return -1;
80105b98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b9d:	c9                   	leave  
80105b9e:	c3                   	ret    

80105b9f <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105b9f:	f3 0f 1e fb          	endbr32 
80105ba3:	55                   	push   %ebp
80105ba4:	89 e5                	mov    %esp,%ebp
80105ba6:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105ba9:	e8 a8 e9 ff ff       	call   80104556 <myproc>
80105bae:	8b 40 18             	mov    0x18(%eax),%eax
80105bb1:	8b 40 44             	mov    0x44(%eax),%eax
80105bb4:	8b 55 08             	mov    0x8(%ebp),%edx
80105bb7:	c1 e2 02             	shl    $0x2,%edx
80105bba:	01 d0                	add    %edx,%eax
80105bbc:	83 c0 04             	add    $0x4,%eax
80105bbf:	83 ec 08             	sub    $0x8,%esp
80105bc2:	ff 75 0c             	pushl  0xc(%ebp)
80105bc5:	50                   	push   %eax
80105bc6:	e8 29 ff ff ff       	call   80105af4 <fetchint>
80105bcb:	83 c4 10             	add    $0x10,%esp
}
80105bce:	c9                   	leave  
80105bcf:	c3                   	ret    

80105bd0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105bd0:	f3 0f 1e fb          	endbr32 
80105bd4:	55                   	push   %ebp
80105bd5:	89 e5                	mov    %esp,%ebp
80105bd7:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
80105bda:	e8 77 e9 ff ff       	call   80104556 <myproc>
80105bdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
80105be2:	83 ec 08             	sub    $0x8,%esp
80105be5:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105be8:	50                   	push   %eax
80105be9:	ff 75 08             	pushl  0x8(%ebp)
80105bec:	e8 ae ff ff ff       	call   80105b9f <argint>
80105bf1:	83 c4 10             	add    $0x10,%esp
80105bf4:	85 c0                	test   %eax,%eax
80105bf6:	79 07                	jns    80105bff <argptr+0x2f>
    return -1;
80105bf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bfd:	eb 3b                	jmp    80105c3a <argptr+0x6a>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105bff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105c03:	78 1f                	js     80105c24 <argptr+0x54>
80105c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c08:	8b 00                	mov    (%eax),%eax
80105c0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c0d:	39 d0                	cmp    %edx,%eax
80105c0f:	76 13                	jbe    80105c24 <argptr+0x54>
80105c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c14:	89 c2                	mov    %eax,%edx
80105c16:	8b 45 10             	mov    0x10(%ebp),%eax
80105c19:	01 c2                	add    %eax,%edx
80105c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c1e:	8b 00                	mov    (%eax),%eax
80105c20:	39 c2                	cmp    %eax,%edx
80105c22:	76 07                	jbe    80105c2b <argptr+0x5b>
    return -1;
80105c24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c29:	eb 0f                	jmp    80105c3a <argptr+0x6a>
  *pp = (char*)i;
80105c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c2e:	89 c2                	mov    %eax,%edx
80105c30:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c33:	89 10                	mov    %edx,(%eax)
  return 0;
80105c35:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c3a:	c9                   	leave  
80105c3b:	c3                   	ret    

80105c3c <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105c3c:	f3 0f 1e fb          	endbr32 
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105c46:	83 ec 08             	sub    $0x8,%esp
80105c49:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c4c:	50                   	push   %eax
80105c4d:	ff 75 08             	pushl  0x8(%ebp)
80105c50:	e8 4a ff ff ff       	call   80105b9f <argint>
80105c55:	83 c4 10             	add    $0x10,%esp
80105c58:	85 c0                	test   %eax,%eax
80105c5a:	79 07                	jns    80105c63 <argstr+0x27>
    return -1;
80105c5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c61:	eb 12                	jmp    80105c75 <argstr+0x39>
  return fetchstr(addr, pp);
80105c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c66:	83 ec 08             	sub    $0x8,%esp
80105c69:	ff 75 0c             	pushl  0xc(%ebp)
80105c6c:	50                   	push   %eax
80105c6d:	e8 c5 fe ff ff       	call   80105b37 <fetchstr>
80105c72:	83 c4 10             	add    $0x10,%esp
}
80105c75:	c9                   	leave  
80105c76:	c3                   	ret    

80105c77 <syscall>:
[SYS_dump_rawphymem] sys_dump_rawphymem,
};

void
syscall(void)
{
80105c77:	f3 0f 1e fb          	endbr32 
80105c7b:	55                   	push   %ebp
80105c7c:	89 e5                	mov    %esp,%ebp
80105c7e:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
80105c81:	e8 d0 e8 ff ff       	call   80104556 <myproc>
80105c86:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
80105c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c8c:	8b 40 18             	mov    0x18(%eax),%eax
80105c8f:	8b 40 1c             	mov    0x1c(%eax),%eax
80105c92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105c95:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c99:	7e 2f                	jle    80105cca <syscall+0x53>
80105c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c9e:	83 f8 18             	cmp    $0x18,%eax
80105ca1:	77 27                	ja     80105cca <syscall+0x53>
80105ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ca6:	8b 04 85 20 d0 10 80 	mov    -0x7fef2fe0(,%eax,4),%eax
80105cad:	85 c0                	test   %eax,%eax
80105caf:	74 19                	je     80105cca <syscall+0x53>
    curproc->tf->eax = syscalls[num]();
80105cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cb4:	8b 04 85 20 d0 10 80 	mov    -0x7fef2fe0(,%eax,4),%eax
80105cbb:	ff d0                	call   *%eax
80105cbd:	89 c2                	mov    %eax,%edx
80105cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cc2:	8b 40 18             	mov    0x18(%eax),%eax
80105cc5:	89 50 1c             	mov    %edx,0x1c(%eax)
80105cc8:	eb 2c                	jmp    80105cf6 <syscall+0x7f>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ccd:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
80105cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cd3:	8b 40 10             	mov    0x10(%eax),%eax
80105cd6:	ff 75 f0             	pushl  -0x10(%ebp)
80105cd9:	52                   	push   %edx
80105cda:	50                   	push   %eax
80105cdb:	68 84 9c 10 80       	push   $0x80109c84
80105ce0:	e8 33 a7 ff ff       	call   80100418 <cprintf>
80105ce5:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
80105ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ceb:	8b 40 18             	mov    0x18(%eax),%eax
80105cee:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105cf5:	90                   	nop
80105cf6:	90                   	nop
80105cf7:	c9                   	leave  
80105cf8:	c3                   	ret    

80105cf9 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105cf9:	f3 0f 1e fb          	endbr32 
80105cfd:	55                   	push   %ebp
80105cfe:	89 e5                	mov    %esp,%ebp
80105d00:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105d03:	83 ec 08             	sub    $0x8,%esp
80105d06:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d09:	50                   	push   %eax
80105d0a:	ff 75 08             	pushl  0x8(%ebp)
80105d0d:	e8 8d fe ff ff       	call   80105b9f <argint>
80105d12:	83 c4 10             	add    $0x10,%esp
80105d15:	85 c0                	test   %eax,%eax
80105d17:	79 07                	jns    80105d20 <argfd+0x27>
    return -1;
80105d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d1e:	eb 4f                	jmp    80105d6f <argfd+0x76>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d23:	85 c0                	test   %eax,%eax
80105d25:	78 20                	js     80105d47 <argfd+0x4e>
80105d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d2a:	83 f8 0f             	cmp    $0xf,%eax
80105d2d:	7f 18                	jg     80105d47 <argfd+0x4e>
80105d2f:	e8 22 e8 ff ff       	call   80104556 <myproc>
80105d34:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d37:	83 c2 08             	add    $0x8,%edx
80105d3a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105d3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d45:	75 07                	jne    80105d4e <argfd+0x55>
    return -1;
80105d47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d4c:	eb 21                	jmp    80105d6f <argfd+0x76>
  if(pfd)
80105d4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105d52:	74 08                	je     80105d5c <argfd+0x63>
    *pfd = fd;
80105d54:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d57:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d5a:	89 10                	mov    %edx,(%eax)
  if(pf)
80105d5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105d60:	74 08                	je     80105d6a <argfd+0x71>
    *pf = f;
80105d62:	8b 45 10             	mov    0x10(%ebp),%eax
80105d65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d68:	89 10                	mov    %edx,(%eax)
  return 0;
80105d6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d6f:	c9                   	leave  
80105d70:	c3                   	ret    

80105d71 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105d71:	f3 0f 1e fb          	endbr32 
80105d75:	55                   	push   %ebp
80105d76:	89 e5                	mov    %esp,%ebp
80105d78:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
80105d7b:	e8 d6 e7 ff ff       	call   80104556 <myproc>
80105d80:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
80105d83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105d8a:	eb 2a                	jmp    80105db6 <fdalloc+0x45>
    if(curproc->ofile[fd] == 0){
80105d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d92:	83 c2 08             	add    $0x8,%edx
80105d95:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105d99:	85 c0                	test   %eax,%eax
80105d9b:	75 15                	jne    80105db2 <fdalloc+0x41>
      curproc->ofile[fd] = f;
80105d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105da0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105da3:	8d 4a 08             	lea    0x8(%edx),%ecx
80105da6:	8b 55 08             	mov    0x8(%ebp),%edx
80105da9:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105db0:	eb 0f                	jmp    80105dc1 <fdalloc+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105db2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105db6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105dba:	7e d0                	jle    80105d8c <fdalloc+0x1b>
    }
  }
  return -1;
80105dbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dc1:	c9                   	leave  
80105dc2:	c3                   	ret    

80105dc3 <sys_dup>:

int
sys_dup(void)
{
80105dc3:	f3 0f 1e fb          	endbr32 
80105dc7:	55                   	push   %ebp
80105dc8:	89 e5                	mov    %esp,%ebp
80105dca:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105dcd:	83 ec 04             	sub    $0x4,%esp
80105dd0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105dd3:	50                   	push   %eax
80105dd4:	6a 00                	push   $0x0
80105dd6:	6a 00                	push   $0x0
80105dd8:	e8 1c ff ff ff       	call   80105cf9 <argfd>
80105ddd:	83 c4 10             	add    $0x10,%esp
80105de0:	85 c0                	test   %eax,%eax
80105de2:	79 07                	jns    80105deb <sys_dup+0x28>
    return -1;
80105de4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105de9:	eb 31                	jmp    80105e1c <sys_dup+0x59>
  if((fd=fdalloc(f)) < 0)
80105deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dee:	83 ec 0c             	sub    $0xc,%esp
80105df1:	50                   	push   %eax
80105df2:	e8 7a ff ff ff       	call   80105d71 <fdalloc>
80105df7:	83 c4 10             	add    $0x10,%esp
80105dfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105dfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e01:	79 07                	jns    80105e0a <sys_dup+0x47>
    return -1;
80105e03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e08:	eb 12                	jmp    80105e1c <sys_dup+0x59>
  filedup(f);
80105e0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e0d:	83 ec 0c             	sub    $0xc,%esp
80105e10:	50                   	push   %eax
80105e11:	e8 43 b3 ff ff       	call   80101159 <filedup>
80105e16:	83 c4 10             	add    $0x10,%esp
  return fd;
80105e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105e1c:	c9                   	leave  
80105e1d:	c3                   	ret    

80105e1e <sys_read>:

int
sys_read(void)
{
80105e1e:	f3 0f 1e fb          	endbr32 
80105e22:	55                   	push   %ebp
80105e23:	89 e5                	mov    %esp,%ebp
80105e25:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105e28:	83 ec 04             	sub    $0x4,%esp
80105e2b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e2e:	50                   	push   %eax
80105e2f:	6a 00                	push   $0x0
80105e31:	6a 00                	push   $0x0
80105e33:	e8 c1 fe ff ff       	call   80105cf9 <argfd>
80105e38:	83 c4 10             	add    $0x10,%esp
80105e3b:	85 c0                	test   %eax,%eax
80105e3d:	78 2e                	js     80105e6d <sys_read+0x4f>
80105e3f:	83 ec 08             	sub    $0x8,%esp
80105e42:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e45:	50                   	push   %eax
80105e46:	6a 02                	push   $0x2
80105e48:	e8 52 fd ff ff       	call   80105b9f <argint>
80105e4d:	83 c4 10             	add    $0x10,%esp
80105e50:	85 c0                	test   %eax,%eax
80105e52:	78 19                	js     80105e6d <sys_read+0x4f>
80105e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e57:	83 ec 04             	sub    $0x4,%esp
80105e5a:	50                   	push   %eax
80105e5b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e5e:	50                   	push   %eax
80105e5f:	6a 01                	push   $0x1
80105e61:	e8 6a fd ff ff       	call   80105bd0 <argptr>
80105e66:	83 c4 10             	add    $0x10,%esp
80105e69:	85 c0                	test   %eax,%eax
80105e6b:	79 07                	jns    80105e74 <sys_read+0x56>
    return -1;
80105e6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e72:	eb 17                	jmp    80105e8b <sys_read+0x6d>
  return fileread(f, p, n);
80105e74:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105e77:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e7d:	83 ec 04             	sub    $0x4,%esp
80105e80:	51                   	push   %ecx
80105e81:	52                   	push   %edx
80105e82:	50                   	push   %eax
80105e83:	e8 6d b4 ff ff       	call   801012f5 <fileread>
80105e88:	83 c4 10             	add    $0x10,%esp
}
80105e8b:	c9                   	leave  
80105e8c:	c3                   	ret    

80105e8d <sys_write>:

int
sys_write(void)
{
80105e8d:	f3 0f 1e fb          	endbr32 
80105e91:	55                   	push   %ebp
80105e92:	89 e5                	mov    %esp,%ebp
80105e94:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105e97:	83 ec 04             	sub    $0x4,%esp
80105e9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e9d:	50                   	push   %eax
80105e9e:	6a 00                	push   $0x0
80105ea0:	6a 00                	push   $0x0
80105ea2:	e8 52 fe ff ff       	call   80105cf9 <argfd>
80105ea7:	83 c4 10             	add    $0x10,%esp
80105eaa:	85 c0                	test   %eax,%eax
80105eac:	78 2e                	js     80105edc <sys_write+0x4f>
80105eae:	83 ec 08             	sub    $0x8,%esp
80105eb1:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105eb4:	50                   	push   %eax
80105eb5:	6a 02                	push   $0x2
80105eb7:	e8 e3 fc ff ff       	call   80105b9f <argint>
80105ebc:	83 c4 10             	add    $0x10,%esp
80105ebf:	85 c0                	test   %eax,%eax
80105ec1:	78 19                	js     80105edc <sys_write+0x4f>
80105ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ec6:	83 ec 04             	sub    $0x4,%esp
80105ec9:	50                   	push   %eax
80105eca:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ecd:	50                   	push   %eax
80105ece:	6a 01                	push   $0x1
80105ed0:	e8 fb fc ff ff       	call   80105bd0 <argptr>
80105ed5:	83 c4 10             	add    $0x10,%esp
80105ed8:	85 c0                	test   %eax,%eax
80105eda:	79 07                	jns    80105ee3 <sys_write+0x56>
    return -1;
80105edc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ee1:	eb 17                	jmp    80105efa <sys_write+0x6d>
  return filewrite(f, p, n);
80105ee3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105ee6:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eec:	83 ec 04             	sub    $0x4,%esp
80105eef:	51                   	push   %ecx
80105ef0:	52                   	push   %edx
80105ef1:	50                   	push   %eax
80105ef2:	e8 ba b4 ff ff       	call   801013b1 <filewrite>
80105ef7:	83 c4 10             	add    $0x10,%esp
}
80105efa:	c9                   	leave  
80105efb:	c3                   	ret    

80105efc <sys_close>:

int
sys_close(void)
{
80105efc:	f3 0f 1e fb          	endbr32 
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105f06:	83 ec 04             	sub    $0x4,%esp
80105f09:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f0c:	50                   	push   %eax
80105f0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f10:	50                   	push   %eax
80105f11:	6a 00                	push   $0x0
80105f13:	e8 e1 fd ff ff       	call   80105cf9 <argfd>
80105f18:	83 c4 10             	add    $0x10,%esp
80105f1b:	85 c0                	test   %eax,%eax
80105f1d:	79 07                	jns    80105f26 <sys_close+0x2a>
    return -1;
80105f1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f24:	eb 27                	jmp    80105f4d <sys_close+0x51>
  myproc()->ofile[fd] = 0;
80105f26:	e8 2b e6 ff ff       	call   80104556 <myproc>
80105f2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f2e:	83 c2 08             	add    $0x8,%edx
80105f31:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105f38:	00 
  fileclose(f);
80105f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f3c:	83 ec 0c             	sub    $0xc,%esp
80105f3f:	50                   	push   %eax
80105f40:	e8 69 b2 ff ff       	call   801011ae <fileclose>
80105f45:	83 c4 10             	add    $0x10,%esp
  return 0;
80105f48:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f4d:	c9                   	leave  
80105f4e:	c3                   	ret    

80105f4f <sys_fstat>:

int
sys_fstat(void)
{
80105f4f:	f3 0f 1e fb          	endbr32 
80105f53:	55                   	push   %ebp
80105f54:	89 e5                	mov    %esp,%ebp
80105f56:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105f59:	83 ec 04             	sub    $0x4,%esp
80105f5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f5f:	50                   	push   %eax
80105f60:	6a 00                	push   $0x0
80105f62:	6a 00                	push   $0x0
80105f64:	e8 90 fd ff ff       	call   80105cf9 <argfd>
80105f69:	83 c4 10             	add    $0x10,%esp
80105f6c:	85 c0                	test   %eax,%eax
80105f6e:	78 17                	js     80105f87 <sys_fstat+0x38>
80105f70:	83 ec 04             	sub    $0x4,%esp
80105f73:	6a 14                	push   $0x14
80105f75:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f78:	50                   	push   %eax
80105f79:	6a 01                	push   $0x1
80105f7b:	e8 50 fc ff ff       	call   80105bd0 <argptr>
80105f80:	83 c4 10             	add    $0x10,%esp
80105f83:	85 c0                	test   %eax,%eax
80105f85:	79 07                	jns    80105f8e <sys_fstat+0x3f>
    return -1;
80105f87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f8c:	eb 13                	jmp    80105fa1 <sys_fstat+0x52>
  return filestat(f, st);
80105f8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f94:	83 ec 08             	sub    $0x8,%esp
80105f97:	52                   	push   %edx
80105f98:	50                   	push   %eax
80105f99:	e8 fc b2 ff ff       	call   8010129a <filestat>
80105f9e:	83 c4 10             	add    $0x10,%esp
}
80105fa1:	c9                   	leave  
80105fa2:	c3                   	ret    

80105fa3 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105fa3:	f3 0f 1e fb          	endbr32 
80105fa7:	55                   	push   %ebp
80105fa8:	89 e5                	mov    %esp,%ebp
80105faa:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105fad:	83 ec 08             	sub    $0x8,%esp
80105fb0:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105fb3:	50                   	push   %eax
80105fb4:	6a 00                	push   $0x0
80105fb6:	e8 81 fc ff ff       	call   80105c3c <argstr>
80105fbb:	83 c4 10             	add    $0x10,%esp
80105fbe:	85 c0                	test   %eax,%eax
80105fc0:	78 15                	js     80105fd7 <sys_link+0x34>
80105fc2:	83 ec 08             	sub    $0x8,%esp
80105fc5:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105fc8:	50                   	push   %eax
80105fc9:	6a 01                	push   $0x1
80105fcb:	e8 6c fc ff ff       	call   80105c3c <argstr>
80105fd0:	83 c4 10             	add    $0x10,%esp
80105fd3:	85 c0                	test   %eax,%eax
80105fd5:	79 0a                	jns    80105fe1 <sys_link+0x3e>
    return -1;
80105fd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fdc:	e9 68 01 00 00       	jmp    80106149 <sys_link+0x1a6>

  begin_op();
80105fe1:	e8 17 d7 ff ff       	call   801036fd <begin_op>
  if((ip = namei(old)) == 0){
80105fe6:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105fe9:	83 ec 0c             	sub    $0xc,%esp
80105fec:	50                   	push   %eax
80105fed:	e8 a7 c6 ff ff       	call   80102699 <namei>
80105ff2:	83 c4 10             	add    $0x10,%esp
80105ff5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ff8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ffc:	75 0f                	jne    8010600d <sys_link+0x6a>
    end_op();
80105ffe:	e8 8a d7 ff ff       	call   8010378d <end_op>
    return -1;
80106003:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106008:	e9 3c 01 00 00       	jmp    80106149 <sys_link+0x1a6>
  }

  ilock(ip);
8010600d:	83 ec 0c             	sub    $0xc,%esp
80106010:	ff 75 f4             	pushl  -0xc(%ebp)
80106013:	e8 16 bb ff ff       	call   80101b2e <ilock>
80106018:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
8010601b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010601e:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106022:	66 83 f8 01          	cmp    $0x1,%ax
80106026:	75 1d                	jne    80106045 <sys_link+0xa2>
    iunlockput(ip);
80106028:	83 ec 0c             	sub    $0xc,%esp
8010602b:	ff 75 f4             	pushl  -0xc(%ebp)
8010602e:	e8 38 bd ff ff       	call   80101d6b <iunlockput>
80106033:	83 c4 10             	add    $0x10,%esp
    end_op();
80106036:	e8 52 d7 ff ff       	call   8010378d <end_op>
    return -1;
8010603b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106040:	e9 04 01 00 00       	jmp    80106149 <sys_link+0x1a6>
  }

  ip->nlink++;
80106045:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106048:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010604c:	83 c0 01             	add    $0x1,%eax
8010604f:	89 c2                	mov    %eax,%edx
80106051:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106054:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80106058:	83 ec 0c             	sub    $0xc,%esp
8010605b:	ff 75 f4             	pushl  -0xc(%ebp)
8010605e:	e8 e2 b8 ff ff       	call   80101945 <iupdate>
80106063:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80106066:	83 ec 0c             	sub    $0xc,%esp
80106069:	ff 75 f4             	pushl  -0xc(%ebp)
8010606c:	e8 d4 bb ff ff       	call   80101c45 <iunlock>
80106071:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80106074:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106077:	83 ec 08             	sub    $0x8,%esp
8010607a:	8d 55 e2             	lea    -0x1e(%ebp),%edx
8010607d:	52                   	push   %edx
8010607e:	50                   	push   %eax
8010607f:	e8 35 c6 ff ff       	call   801026b9 <nameiparent>
80106084:	83 c4 10             	add    $0x10,%esp
80106087:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010608a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010608e:	74 71                	je     80106101 <sys_link+0x15e>
    goto bad;
  ilock(dp);
80106090:	83 ec 0c             	sub    $0xc,%esp
80106093:	ff 75 f0             	pushl  -0x10(%ebp)
80106096:	e8 93 ba ff ff       	call   80101b2e <ilock>
8010609b:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010609e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060a1:	8b 10                	mov    (%eax),%edx
801060a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060a6:	8b 00                	mov    (%eax),%eax
801060a8:	39 c2                	cmp    %eax,%edx
801060aa:	75 1d                	jne    801060c9 <sys_link+0x126>
801060ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060af:	8b 40 04             	mov    0x4(%eax),%eax
801060b2:	83 ec 04             	sub    $0x4,%esp
801060b5:	50                   	push   %eax
801060b6:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801060b9:	50                   	push   %eax
801060ba:	ff 75 f0             	pushl  -0x10(%ebp)
801060bd:	e8 34 c3 ff ff       	call   801023f6 <dirlink>
801060c2:	83 c4 10             	add    $0x10,%esp
801060c5:	85 c0                	test   %eax,%eax
801060c7:	79 10                	jns    801060d9 <sys_link+0x136>
    iunlockput(dp);
801060c9:	83 ec 0c             	sub    $0xc,%esp
801060cc:	ff 75 f0             	pushl  -0x10(%ebp)
801060cf:	e8 97 bc ff ff       	call   80101d6b <iunlockput>
801060d4:	83 c4 10             	add    $0x10,%esp
    goto bad;
801060d7:	eb 29                	jmp    80106102 <sys_link+0x15f>
  }
  iunlockput(dp);
801060d9:	83 ec 0c             	sub    $0xc,%esp
801060dc:	ff 75 f0             	pushl  -0x10(%ebp)
801060df:	e8 87 bc ff ff       	call   80101d6b <iunlockput>
801060e4:	83 c4 10             	add    $0x10,%esp
  iput(ip);
801060e7:	83 ec 0c             	sub    $0xc,%esp
801060ea:	ff 75 f4             	pushl  -0xc(%ebp)
801060ed:	e8 a5 bb ff ff       	call   80101c97 <iput>
801060f2:	83 c4 10             	add    $0x10,%esp

  end_op();
801060f5:	e8 93 d6 ff ff       	call   8010378d <end_op>

  return 0;
801060fa:	b8 00 00 00 00       	mov    $0x0,%eax
801060ff:	eb 48                	jmp    80106149 <sys_link+0x1a6>
    goto bad;
80106101:	90                   	nop

bad:
  ilock(ip);
80106102:	83 ec 0c             	sub    $0xc,%esp
80106105:	ff 75 f4             	pushl  -0xc(%ebp)
80106108:	e8 21 ba ff ff       	call   80101b2e <ilock>
8010610d:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80106110:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106113:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106117:	83 e8 01             	sub    $0x1,%eax
8010611a:	89 c2                	mov    %eax,%edx
8010611c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010611f:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80106123:	83 ec 0c             	sub    $0xc,%esp
80106126:	ff 75 f4             	pushl  -0xc(%ebp)
80106129:	e8 17 b8 ff ff       	call   80101945 <iupdate>
8010612e:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106131:	83 ec 0c             	sub    $0xc,%esp
80106134:	ff 75 f4             	pushl  -0xc(%ebp)
80106137:	e8 2f bc ff ff       	call   80101d6b <iunlockput>
8010613c:	83 c4 10             	add    $0x10,%esp
  end_op();
8010613f:	e8 49 d6 ff ff       	call   8010378d <end_op>
  return -1;
80106144:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106149:	c9                   	leave  
8010614a:	c3                   	ret    

8010614b <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010614b:	f3 0f 1e fb          	endbr32 
8010614f:	55                   	push   %ebp
80106150:	89 e5                	mov    %esp,%ebp
80106152:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106155:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
8010615c:	eb 40                	jmp    8010619e <isdirempty+0x53>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010615e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106161:	6a 10                	push   $0x10
80106163:	50                   	push   %eax
80106164:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106167:	50                   	push   %eax
80106168:	ff 75 08             	pushl  0x8(%ebp)
8010616b:	e8 c6 be ff ff       	call   80102036 <readi>
80106170:	83 c4 10             	add    $0x10,%esp
80106173:	83 f8 10             	cmp    $0x10,%eax
80106176:	74 0d                	je     80106185 <isdirempty+0x3a>
      panic("isdirempty: readi");
80106178:	83 ec 0c             	sub    $0xc,%esp
8010617b:	68 a0 9c 10 80       	push   $0x80109ca0
80106180:	e8 83 a4 ff ff       	call   80100608 <panic>
    if(de.inum != 0)
80106185:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106189:	66 85 c0             	test   %ax,%ax
8010618c:	74 07                	je     80106195 <isdirempty+0x4a>
      return 0;
8010618e:	b8 00 00 00 00       	mov    $0x0,%eax
80106193:	eb 1b                	jmp    801061b0 <isdirempty+0x65>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106198:	83 c0 10             	add    $0x10,%eax
8010619b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010619e:	8b 45 08             	mov    0x8(%ebp),%eax
801061a1:	8b 50 58             	mov    0x58(%eax),%edx
801061a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061a7:	39 c2                	cmp    %eax,%edx
801061a9:	77 b3                	ja     8010615e <isdirempty+0x13>
  }
  return 1;
801061ab:	b8 01 00 00 00       	mov    $0x1,%eax
}
801061b0:	c9                   	leave  
801061b1:	c3                   	ret    

801061b2 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801061b2:	f3 0f 1e fb          	endbr32 
801061b6:	55                   	push   %ebp
801061b7:	89 e5                	mov    %esp,%ebp
801061b9:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801061bc:	83 ec 08             	sub    $0x8,%esp
801061bf:	8d 45 cc             	lea    -0x34(%ebp),%eax
801061c2:	50                   	push   %eax
801061c3:	6a 00                	push   $0x0
801061c5:	e8 72 fa ff ff       	call   80105c3c <argstr>
801061ca:	83 c4 10             	add    $0x10,%esp
801061cd:	85 c0                	test   %eax,%eax
801061cf:	79 0a                	jns    801061db <sys_unlink+0x29>
    return -1;
801061d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061d6:	e9 bf 01 00 00       	jmp    8010639a <sys_unlink+0x1e8>

  begin_op();
801061db:	e8 1d d5 ff ff       	call   801036fd <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801061e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
801061e3:	83 ec 08             	sub    $0x8,%esp
801061e6:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801061e9:	52                   	push   %edx
801061ea:	50                   	push   %eax
801061eb:	e8 c9 c4 ff ff       	call   801026b9 <nameiparent>
801061f0:	83 c4 10             	add    $0x10,%esp
801061f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801061f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061fa:	75 0f                	jne    8010620b <sys_unlink+0x59>
    end_op();
801061fc:	e8 8c d5 ff ff       	call   8010378d <end_op>
    return -1;
80106201:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106206:	e9 8f 01 00 00       	jmp    8010639a <sys_unlink+0x1e8>
  }

  ilock(dp);
8010620b:	83 ec 0c             	sub    $0xc,%esp
8010620e:	ff 75 f4             	pushl  -0xc(%ebp)
80106211:	e8 18 b9 ff ff       	call   80101b2e <ilock>
80106216:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106219:	83 ec 08             	sub    $0x8,%esp
8010621c:	68 b2 9c 10 80       	push   $0x80109cb2
80106221:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106224:	50                   	push   %eax
80106225:	e8 ef c0 ff ff       	call   80102319 <namecmp>
8010622a:	83 c4 10             	add    $0x10,%esp
8010622d:	85 c0                	test   %eax,%eax
8010622f:	0f 84 49 01 00 00    	je     8010637e <sys_unlink+0x1cc>
80106235:	83 ec 08             	sub    $0x8,%esp
80106238:	68 b4 9c 10 80       	push   $0x80109cb4
8010623d:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106240:	50                   	push   %eax
80106241:	e8 d3 c0 ff ff       	call   80102319 <namecmp>
80106246:	83 c4 10             	add    $0x10,%esp
80106249:	85 c0                	test   %eax,%eax
8010624b:	0f 84 2d 01 00 00    	je     8010637e <sys_unlink+0x1cc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106251:	83 ec 04             	sub    $0x4,%esp
80106254:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106257:	50                   	push   %eax
80106258:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010625b:	50                   	push   %eax
8010625c:	ff 75 f4             	pushl  -0xc(%ebp)
8010625f:	e8 d4 c0 ff ff       	call   80102338 <dirlookup>
80106264:	83 c4 10             	add    $0x10,%esp
80106267:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010626a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010626e:	0f 84 0d 01 00 00    	je     80106381 <sys_unlink+0x1cf>
    goto bad;
  ilock(ip);
80106274:	83 ec 0c             	sub    $0xc,%esp
80106277:	ff 75 f0             	pushl  -0x10(%ebp)
8010627a:	e8 af b8 ff ff       	call   80101b2e <ilock>
8010627f:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80106282:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106285:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106289:	66 85 c0             	test   %ax,%ax
8010628c:	7f 0d                	jg     8010629b <sys_unlink+0xe9>
    panic("unlink: nlink < 1");
8010628e:	83 ec 0c             	sub    $0xc,%esp
80106291:	68 b7 9c 10 80       	push   $0x80109cb7
80106296:	e8 6d a3 ff ff       	call   80100608 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010629b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010629e:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801062a2:	66 83 f8 01          	cmp    $0x1,%ax
801062a6:	75 25                	jne    801062cd <sys_unlink+0x11b>
801062a8:	83 ec 0c             	sub    $0xc,%esp
801062ab:	ff 75 f0             	pushl  -0x10(%ebp)
801062ae:	e8 98 fe ff ff       	call   8010614b <isdirempty>
801062b3:	83 c4 10             	add    $0x10,%esp
801062b6:	85 c0                	test   %eax,%eax
801062b8:	75 13                	jne    801062cd <sys_unlink+0x11b>
    iunlockput(ip);
801062ba:	83 ec 0c             	sub    $0xc,%esp
801062bd:	ff 75 f0             	pushl  -0x10(%ebp)
801062c0:	e8 a6 ba ff ff       	call   80101d6b <iunlockput>
801062c5:	83 c4 10             	add    $0x10,%esp
    goto bad;
801062c8:	e9 b5 00 00 00       	jmp    80106382 <sys_unlink+0x1d0>
  }

  memset(&de, 0, sizeof(de));
801062cd:	83 ec 04             	sub    $0x4,%esp
801062d0:	6a 10                	push   $0x10
801062d2:	6a 00                	push   $0x0
801062d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801062d7:	50                   	push   %eax
801062d8:	e8 6e f5 ff ff       	call   8010584b <memset>
801062dd:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801062e0:	8b 45 c8             	mov    -0x38(%ebp),%eax
801062e3:	6a 10                	push   $0x10
801062e5:	50                   	push   %eax
801062e6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801062e9:	50                   	push   %eax
801062ea:	ff 75 f4             	pushl  -0xc(%ebp)
801062ed:	e8 9d be ff ff       	call   8010218f <writei>
801062f2:	83 c4 10             	add    $0x10,%esp
801062f5:	83 f8 10             	cmp    $0x10,%eax
801062f8:	74 0d                	je     80106307 <sys_unlink+0x155>
    panic("unlink: writei");
801062fa:	83 ec 0c             	sub    $0xc,%esp
801062fd:	68 c9 9c 10 80       	push   $0x80109cc9
80106302:	e8 01 a3 ff ff       	call   80100608 <panic>
  if(ip->type == T_DIR){
80106307:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010630a:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010630e:	66 83 f8 01          	cmp    $0x1,%ax
80106312:	75 21                	jne    80106335 <sys_unlink+0x183>
    dp->nlink--;
80106314:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106317:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010631b:	83 e8 01             	sub    $0x1,%eax
8010631e:	89 c2                	mov    %eax,%edx
80106320:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106323:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80106327:	83 ec 0c             	sub    $0xc,%esp
8010632a:	ff 75 f4             	pushl  -0xc(%ebp)
8010632d:	e8 13 b6 ff ff       	call   80101945 <iupdate>
80106332:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80106335:	83 ec 0c             	sub    $0xc,%esp
80106338:	ff 75 f4             	pushl  -0xc(%ebp)
8010633b:	e8 2b ba ff ff       	call   80101d6b <iunlockput>
80106340:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80106343:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106346:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010634a:	83 e8 01             	sub    $0x1,%eax
8010634d:	89 c2                	mov    %eax,%edx
8010634f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106352:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80106356:	83 ec 0c             	sub    $0xc,%esp
80106359:	ff 75 f0             	pushl  -0x10(%ebp)
8010635c:	e8 e4 b5 ff ff       	call   80101945 <iupdate>
80106361:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106364:	83 ec 0c             	sub    $0xc,%esp
80106367:	ff 75 f0             	pushl  -0x10(%ebp)
8010636a:	e8 fc b9 ff ff       	call   80101d6b <iunlockput>
8010636f:	83 c4 10             	add    $0x10,%esp

  end_op();
80106372:	e8 16 d4 ff ff       	call   8010378d <end_op>

  return 0;
80106377:	b8 00 00 00 00       	mov    $0x0,%eax
8010637c:	eb 1c                	jmp    8010639a <sys_unlink+0x1e8>
    goto bad;
8010637e:	90                   	nop
8010637f:	eb 01                	jmp    80106382 <sys_unlink+0x1d0>
    goto bad;
80106381:	90                   	nop

bad:
  iunlockput(dp);
80106382:	83 ec 0c             	sub    $0xc,%esp
80106385:	ff 75 f4             	pushl  -0xc(%ebp)
80106388:	e8 de b9 ff ff       	call   80101d6b <iunlockput>
8010638d:	83 c4 10             	add    $0x10,%esp
  end_op();
80106390:	e8 f8 d3 ff ff       	call   8010378d <end_op>
  return -1;
80106395:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010639a:	c9                   	leave  
8010639b:	c3                   	ret    

8010639c <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010639c:	f3 0f 1e fb          	endbr32 
801063a0:	55                   	push   %ebp
801063a1:	89 e5                	mov    %esp,%ebp
801063a3:	83 ec 38             	sub    $0x38,%esp
801063a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801063a9:	8b 55 10             	mov    0x10(%ebp),%edx
801063ac:	8b 45 14             	mov    0x14(%ebp),%eax
801063af:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801063b3:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801063b7:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801063bb:	83 ec 08             	sub    $0x8,%esp
801063be:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801063c1:	50                   	push   %eax
801063c2:	ff 75 08             	pushl  0x8(%ebp)
801063c5:	e8 ef c2 ff ff       	call   801026b9 <nameiparent>
801063ca:	83 c4 10             	add    $0x10,%esp
801063cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801063d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063d4:	75 0a                	jne    801063e0 <create+0x44>
    return 0;
801063d6:	b8 00 00 00 00       	mov    $0x0,%eax
801063db:	e9 8e 01 00 00       	jmp    8010656e <create+0x1d2>
  ilock(dp);
801063e0:	83 ec 0c             	sub    $0xc,%esp
801063e3:	ff 75 f4             	pushl  -0xc(%ebp)
801063e6:	e8 43 b7 ff ff       	call   80101b2e <ilock>
801063eb:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, 0)) != 0){
801063ee:	83 ec 04             	sub    $0x4,%esp
801063f1:	6a 00                	push   $0x0
801063f3:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801063f6:	50                   	push   %eax
801063f7:	ff 75 f4             	pushl  -0xc(%ebp)
801063fa:	e8 39 bf ff ff       	call   80102338 <dirlookup>
801063ff:	83 c4 10             	add    $0x10,%esp
80106402:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106405:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106409:	74 50                	je     8010645b <create+0xbf>
    iunlockput(dp);
8010640b:	83 ec 0c             	sub    $0xc,%esp
8010640e:	ff 75 f4             	pushl  -0xc(%ebp)
80106411:	e8 55 b9 ff ff       	call   80101d6b <iunlockput>
80106416:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80106419:	83 ec 0c             	sub    $0xc,%esp
8010641c:	ff 75 f0             	pushl  -0x10(%ebp)
8010641f:	e8 0a b7 ff ff       	call   80101b2e <ilock>
80106424:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80106427:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010642c:	75 15                	jne    80106443 <create+0xa7>
8010642e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106431:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106435:	66 83 f8 02          	cmp    $0x2,%ax
80106439:	75 08                	jne    80106443 <create+0xa7>
      return ip;
8010643b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010643e:	e9 2b 01 00 00       	jmp    8010656e <create+0x1d2>
    iunlockput(ip);
80106443:	83 ec 0c             	sub    $0xc,%esp
80106446:	ff 75 f0             	pushl  -0x10(%ebp)
80106449:	e8 1d b9 ff ff       	call   80101d6b <iunlockput>
8010644e:	83 c4 10             	add    $0x10,%esp
    return 0;
80106451:	b8 00 00 00 00       	mov    $0x0,%eax
80106456:	e9 13 01 00 00       	jmp    8010656e <create+0x1d2>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
8010645b:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010645f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106462:	8b 00                	mov    (%eax),%eax
80106464:	83 ec 08             	sub    $0x8,%esp
80106467:	52                   	push   %edx
80106468:	50                   	push   %eax
80106469:	e8 fc b3 ff ff       	call   8010186a <ialloc>
8010646e:	83 c4 10             	add    $0x10,%esp
80106471:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106474:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106478:	75 0d                	jne    80106487 <create+0xeb>
    panic("create: ialloc");
8010647a:	83 ec 0c             	sub    $0xc,%esp
8010647d:	68 d8 9c 10 80       	push   $0x80109cd8
80106482:	e8 81 a1 ff ff       	call   80100608 <panic>

  ilock(ip);
80106487:	83 ec 0c             	sub    $0xc,%esp
8010648a:	ff 75 f0             	pushl  -0x10(%ebp)
8010648d:	e8 9c b6 ff ff       	call   80101b2e <ilock>
80106492:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80106495:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106498:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
8010649c:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
801064a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064a3:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801064a7:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
801064ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064ae:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
801064b4:	83 ec 0c             	sub    $0xc,%esp
801064b7:	ff 75 f0             	pushl  -0x10(%ebp)
801064ba:	e8 86 b4 ff ff       	call   80101945 <iupdate>
801064bf:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801064c2:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801064c7:	75 6a                	jne    80106533 <create+0x197>
    dp->nlink++;  // for ".."
801064c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064cc:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801064d0:	83 c0 01             	add    $0x1,%eax
801064d3:	89 c2                	mov    %eax,%edx
801064d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064d8:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
801064dc:	83 ec 0c             	sub    $0xc,%esp
801064df:	ff 75 f4             	pushl  -0xc(%ebp)
801064e2:	e8 5e b4 ff ff       	call   80101945 <iupdate>
801064e7:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801064ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064ed:	8b 40 04             	mov    0x4(%eax),%eax
801064f0:	83 ec 04             	sub    $0x4,%esp
801064f3:	50                   	push   %eax
801064f4:	68 b2 9c 10 80       	push   $0x80109cb2
801064f9:	ff 75 f0             	pushl  -0x10(%ebp)
801064fc:	e8 f5 be ff ff       	call   801023f6 <dirlink>
80106501:	83 c4 10             	add    $0x10,%esp
80106504:	85 c0                	test   %eax,%eax
80106506:	78 1e                	js     80106526 <create+0x18a>
80106508:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010650b:	8b 40 04             	mov    0x4(%eax),%eax
8010650e:	83 ec 04             	sub    $0x4,%esp
80106511:	50                   	push   %eax
80106512:	68 b4 9c 10 80       	push   $0x80109cb4
80106517:	ff 75 f0             	pushl  -0x10(%ebp)
8010651a:	e8 d7 be ff ff       	call   801023f6 <dirlink>
8010651f:	83 c4 10             	add    $0x10,%esp
80106522:	85 c0                	test   %eax,%eax
80106524:	79 0d                	jns    80106533 <create+0x197>
      panic("create dots");
80106526:	83 ec 0c             	sub    $0xc,%esp
80106529:	68 e7 9c 10 80       	push   $0x80109ce7
8010652e:	e8 d5 a0 ff ff       	call   80100608 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106533:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106536:	8b 40 04             	mov    0x4(%eax),%eax
80106539:	83 ec 04             	sub    $0x4,%esp
8010653c:	50                   	push   %eax
8010653d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106540:	50                   	push   %eax
80106541:	ff 75 f4             	pushl  -0xc(%ebp)
80106544:	e8 ad be ff ff       	call   801023f6 <dirlink>
80106549:	83 c4 10             	add    $0x10,%esp
8010654c:	85 c0                	test   %eax,%eax
8010654e:	79 0d                	jns    8010655d <create+0x1c1>
    panic("create: dirlink");
80106550:	83 ec 0c             	sub    $0xc,%esp
80106553:	68 f3 9c 10 80       	push   $0x80109cf3
80106558:	e8 ab a0 ff ff       	call   80100608 <panic>

  iunlockput(dp);
8010655d:	83 ec 0c             	sub    $0xc,%esp
80106560:	ff 75 f4             	pushl  -0xc(%ebp)
80106563:	e8 03 b8 ff ff       	call   80101d6b <iunlockput>
80106568:	83 c4 10             	add    $0x10,%esp

  return ip;
8010656b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010656e:	c9                   	leave  
8010656f:	c3                   	ret    

80106570 <sys_open>:

int
sys_open(void)
{
80106570:	f3 0f 1e fb          	endbr32 
80106574:	55                   	push   %ebp
80106575:	89 e5                	mov    %esp,%ebp
80106577:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010657a:	83 ec 08             	sub    $0x8,%esp
8010657d:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106580:	50                   	push   %eax
80106581:	6a 00                	push   $0x0
80106583:	e8 b4 f6 ff ff       	call   80105c3c <argstr>
80106588:	83 c4 10             	add    $0x10,%esp
8010658b:	85 c0                	test   %eax,%eax
8010658d:	78 15                	js     801065a4 <sys_open+0x34>
8010658f:	83 ec 08             	sub    $0x8,%esp
80106592:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106595:	50                   	push   %eax
80106596:	6a 01                	push   $0x1
80106598:	e8 02 f6 ff ff       	call   80105b9f <argint>
8010659d:	83 c4 10             	add    $0x10,%esp
801065a0:	85 c0                	test   %eax,%eax
801065a2:	79 0a                	jns    801065ae <sys_open+0x3e>
    return -1;
801065a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065a9:	e9 61 01 00 00       	jmp    8010670f <sys_open+0x19f>

  begin_op();
801065ae:	e8 4a d1 ff ff       	call   801036fd <begin_op>

  if(omode & O_CREATE){
801065b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065b6:	25 00 02 00 00       	and    $0x200,%eax
801065bb:	85 c0                	test   %eax,%eax
801065bd:	74 2a                	je     801065e9 <sys_open+0x79>
    ip = create(path, T_FILE, 0, 0);
801065bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801065c2:	6a 00                	push   $0x0
801065c4:	6a 00                	push   $0x0
801065c6:	6a 02                	push   $0x2
801065c8:	50                   	push   %eax
801065c9:	e8 ce fd ff ff       	call   8010639c <create>
801065ce:	83 c4 10             	add    $0x10,%esp
801065d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801065d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065d8:	75 75                	jne    8010664f <sys_open+0xdf>
      end_op();
801065da:	e8 ae d1 ff ff       	call   8010378d <end_op>
      return -1;
801065df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065e4:	e9 26 01 00 00       	jmp    8010670f <sys_open+0x19f>
    }
  } else {
    if((ip = namei(path)) == 0){
801065e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801065ec:	83 ec 0c             	sub    $0xc,%esp
801065ef:	50                   	push   %eax
801065f0:	e8 a4 c0 ff ff       	call   80102699 <namei>
801065f5:	83 c4 10             	add    $0x10,%esp
801065f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801065fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065ff:	75 0f                	jne    80106610 <sys_open+0xa0>
      end_op();
80106601:	e8 87 d1 ff ff       	call   8010378d <end_op>
      return -1;
80106606:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010660b:	e9 ff 00 00 00       	jmp    8010670f <sys_open+0x19f>
    }
    ilock(ip);
80106610:	83 ec 0c             	sub    $0xc,%esp
80106613:	ff 75 f4             	pushl  -0xc(%ebp)
80106616:	e8 13 b5 ff ff       	call   80101b2e <ilock>
8010661b:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
8010661e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106621:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106625:	66 83 f8 01          	cmp    $0x1,%ax
80106629:	75 24                	jne    8010664f <sys_open+0xdf>
8010662b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010662e:	85 c0                	test   %eax,%eax
80106630:	74 1d                	je     8010664f <sys_open+0xdf>
      iunlockput(ip);
80106632:	83 ec 0c             	sub    $0xc,%esp
80106635:	ff 75 f4             	pushl  -0xc(%ebp)
80106638:	e8 2e b7 ff ff       	call   80101d6b <iunlockput>
8010663d:	83 c4 10             	add    $0x10,%esp
      end_op();
80106640:	e8 48 d1 ff ff       	call   8010378d <end_op>
      return -1;
80106645:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010664a:	e9 c0 00 00 00       	jmp    8010670f <sys_open+0x19f>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010664f:	e8 94 aa ff ff       	call   801010e8 <filealloc>
80106654:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106657:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010665b:	74 17                	je     80106674 <sys_open+0x104>
8010665d:	83 ec 0c             	sub    $0xc,%esp
80106660:	ff 75 f0             	pushl  -0x10(%ebp)
80106663:	e8 09 f7 ff ff       	call   80105d71 <fdalloc>
80106668:	83 c4 10             	add    $0x10,%esp
8010666b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010666e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106672:	79 2e                	jns    801066a2 <sys_open+0x132>
    if(f)
80106674:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106678:	74 0e                	je     80106688 <sys_open+0x118>
      fileclose(f);
8010667a:	83 ec 0c             	sub    $0xc,%esp
8010667d:	ff 75 f0             	pushl  -0x10(%ebp)
80106680:	e8 29 ab ff ff       	call   801011ae <fileclose>
80106685:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106688:	83 ec 0c             	sub    $0xc,%esp
8010668b:	ff 75 f4             	pushl  -0xc(%ebp)
8010668e:	e8 d8 b6 ff ff       	call   80101d6b <iunlockput>
80106693:	83 c4 10             	add    $0x10,%esp
    end_op();
80106696:	e8 f2 d0 ff ff       	call   8010378d <end_op>
    return -1;
8010669b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066a0:	eb 6d                	jmp    8010670f <sys_open+0x19f>
  }
  iunlock(ip);
801066a2:	83 ec 0c             	sub    $0xc,%esp
801066a5:	ff 75 f4             	pushl  -0xc(%ebp)
801066a8:	e8 98 b5 ff ff       	call   80101c45 <iunlock>
801066ad:	83 c4 10             	add    $0x10,%esp
  end_op();
801066b0:	e8 d8 d0 ff ff       	call   8010378d <end_op>

  f->type = FD_INODE;
801066b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066b8:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801066be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801066c4:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801066c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066ca:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801066d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066d4:	83 e0 01             	and    $0x1,%eax
801066d7:	85 c0                	test   %eax,%eax
801066d9:	0f 94 c0             	sete   %al
801066dc:	89 c2                	mov    %eax,%edx
801066de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066e1:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801066e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066e7:	83 e0 01             	and    $0x1,%eax
801066ea:	85 c0                	test   %eax,%eax
801066ec:	75 0a                	jne    801066f8 <sys_open+0x188>
801066ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066f1:	83 e0 02             	and    $0x2,%eax
801066f4:	85 c0                	test   %eax,%eax
801066f6:	74 07                	je     801066ff <sys_open+0x18f>
801066f8:	b8 01 00 00 00       	mov    $0x1,%eax
801066fd:	eb 05                	jmp    80106704 <sys_open+0x194>
801066ff:	b8 00 00 00 00       	mov    $0x0,%eax
80106704:	89 c2                	mov    %eax,%edx
80106706:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106709:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010670c:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010670f:	c9                   	leave  
80106710:	c3                   	ret    

80106711 <sys_mkdir>:

int
sys_mkdir(void)
{
80106711:	f3 0f 1e fb          	endbr32 
80106715:	55                   	push   %ebp
80106716:	89 e5                	mov    %esp,%ebp
80106718:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010671b:	e8 dd cf ff ff       	call   801036fd <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106720:	83 ec 08             	sub    $0x8,%esp
80106723:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106726:	50                   	push   %eax
80106727:	6a 00                	push   $0x0
80106729:	e8 0e f5 ff ff       	call   80105c3c <argstr>
8010672e:	83 c4 10             	add    $0x10,%esp
80106731:	85 c0                	test   %eax,%eax
80106733:	78 1b                	js     80106750 <sys_mkdir+0x3f>
80106735:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106738:	6a 00                	push   $0x0
8010673a:	6a 00                	push   $0x0
8010673c:	6a 01                	push   $0x1
8010673e:	50                   	push   %eax
8010673f:	e8 58 fc ff ff       	call   8010639c <create>
80106744:	83 c4 10             	add    $0x10,%esp
80106747:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010674a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010674e:	75 0c                	jne    8010675c <sys_mkdir+0x4b>
    end_op();
80106750:	e8 38 d0 ff ff       	call   8010378d <end_op>
    return -1;
80106755:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010675a:	eb 18                	jmp    80106774 <sys_mkdir+0x63>
  }
  iunlockput(ip);
8010675c:	83 ec 0c             	sub    $0xc,%esp
8010675f:	ff 75 f4             	pushl  -0xc(%ebp)
80106762:	e8 04 b6 ff ff       	call   80101d6b <iunlockput>
80106767:	83 c4 10             	add    $0x10,%esp
  end_op();
8010676a:	e8 1e d0 ff ff       	call   8010378d <end_op>
  return 0;
8010676f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106774:	c9                   	leave  
80106775:	c3                   	ret    

80106776 <sys_mknod>:

int
sys_mknod(void)
{
80106776:	f3 0f 1e fb          	endbr32 
8010677a:	55                   	push   %ebp
8010677b:	89 e5                	mov    %esp,%ebp
8010677d:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106780:	e8 78 cf ff ff       	call   801036fd <begin_op>
  if((argstr(0, &path)) < 0 ||
80106785:	83 ec 08             	sub    $0x8,%esp
80106788:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010678b:	50                   	push   %eax
8010678c:	6a 00                	push   $0x0
8010678e:	e8 a9 f4 ff ff       	call   80105c3c <argstr>
80106793:	83 c4 10             	add    $0x10,%esp
80106796:	85 c0                	test   %eax,%eax
80106798:	78 4f                	js     801067e9 <sys_mknod+0x73>
     argint(1, &major) < 0 ||
8010679a:	83 ec 08             	sub    $0x8,%esp
8010679d:	8d 45 ec             	lea    -0x14(%ebp),%eax
801067a0:	50                   	push   %eax
801067a1:	6a 01                	push   $0x1
801067a3:	e8 f7 f3 ff ff       	call   80105b9f <argint>
801067a8:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
801067ab:	85 c0                	test   %eax,%eax
801067ad:	78 3a                	js     801067e9 <sys_mknod+0x73>
     argint(2, &minor) < 0 ||
801067af:	83 ec 08             	sub    $0x8,%esp
801067b2:	8d 45 e8             	lea    -0x18(%ebp),%eax
801067b5:	50                   	push   %eax
801067b6:	6a 02                	push   $0x2
801067b8:	e8 e2 f3 ff ff       	call   80105b9f <argint>
801067bd:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
801067c0:	85 c0                	test   %eax,%eax
801067c2:	78 25                	js     801067e9 <sys_mknod+0x73>
     (ip = create(path, T_DEV, major, minor)) == 0){
801067c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801067c7:	0f bf c8             	movswl %ax,%ecx
801067ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
801067cd:	0f bf d0             	movswl %ax,%edx
801067d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067d3:	51                   	push   %ecx
801067d4:	52                   	push   %edx
801067d5:	6a 03                	push   $0x3
801067d7:	50                   	push   %eax
801067d8:	e8 bf fb ff ff       	call   8010639c <create>
801067dd:	83 c4 10             	add    $0x10,%esp
801067e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
     argint(2, &minor) < 0 ||
801067e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801067e7:	75 0c                	jne    801067f5 <sys_mknod+0x7f>
    end_op();
801067e9:	e8 9f cf ff ff       	call   8010378d <end_op>
    return -1;
801067ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067f3:	eb 18                	jmp    8010680d <sys_mknod+0x97>
  }
  iunlockput(ip);
801067f5:	83 ec 0c             	sub    $0xc,%esp
801067f8:	ff 75 f4             	pushl  -0xc(%ebp)
801067fb:	e8 6b b5 ff ff       	call   80101d6b <iunlockput>
80106800:	83 c4 10             	add    $0x10,%esp
  end_op();
80106803:	e8 85 cf ff ff       	call   8010378d <end_op>
  return 0;
80106808:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010680d:	c9                   	leave  
8010680e:	c3                   	ret    

8010680f <sys_chdir>:

int
sys_chdir(void)
{
8010680f:	f3 0f 1e fb          	endbr32 
80106813:	55                   	push   %ebp
80106814:	89 e5                	mov    %esp,%ebp
80106816:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106819:	e8 38 dd ff ff       	call   80104556 <myproc>
8010681e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80106821:	e8 d7 ce ff ff       	call   801036fd <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106826:	83 ec 08             	sub    $0x8,%esp
80106829:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010682c:	50                   	push   %eax
8010682d:	6a 00                	push   $0x0
8010682f:	e8 08 f4 ff ff       	call   80105c3c <argstr>
80106834:	83 c4 10             	add    $0x10,%esp
80106837:	85 c0                	test   %eax,%eax
80106839:	78 18                	js     80106853 <sys_chdir+0x44>
8010683b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010683e:	83 ec 0c             	sub    $0xc,%esp
80106841:	50                   	push   %eax
80106842:	e8 52 be ff ff       	call   80102699 <namei>
80106847:	83 c4 10             	add    $0x10,%esp
8010684a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010684d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106851:	75 0c                	jne    8010685f <sys_chdir+0x50>
    end_op();
80106853:	e8 35 cf ff ff       	call   8010378d <end_op>
    return -1;
80106858:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010685d:	eb 68                	jmp    801068c7 <sys_chdir+0xb8>
  }
  ilock(ip);
8010685f:	83 ec 0c             	sub    $0xc,%esp
80106862:	ff 75 f0             	pushl  -0x10(%ebp)
80106865:	e8 c4 b2 ff ff       	call   80101b2e <ilock>
8010686a:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
8010686d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106870:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106874:	66 83 f8 01          	cmp    $0x1,%ax
80106878:	74 1a                	je     80106894 <sys_chdir+0x85>
    iunlockput(ip);
8010687a:	83 ec 0c             	sub    $0xc,%esp
8010687d:	ff 75 f0             	pushl  -0x10(%ebp)
80106880:	e8 e6 b4 ff ff       	call   80101d6b <iunlockput>
80106885:	83 c4 10             	add    $0x10,%esp
    end_op();
80106888:	e8 00 cf ff ff       	call   8010378d <end_op>
    return -1;
8010688d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106892:	eb 33                	jmp    801068c7 <sys_chdir+0xb8>
  }
  iunlock(ip);
80106894:	83 ec 0c             	sub    $0xc,%esp
80106897:	ff 75 f0             	pushl  -0x10(%ebp)
8010689a:	e8 a6 b3 ff ff       	call   80101c45 <iunlock>
8010689f:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
801068a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068a5:	8b 40 68             	mov    0x68(%eax),%eax
801068a8:	83 ec 0c             	sub    $0xc,%esp
801068ab:	50                   	push   %eax
801068ac:	e8 e6 b3 ff ff       	call   80101c97 <iput>
801068b1:	83 c4 10             	add    $0x10,%esp
  end_op();
801068b4:	e8 d4 ce ff ff       	call   8010378d <end_op>
  curproc->cwd = ip;
801068b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801068bf:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801068c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801068c7:	c9                   	leave  
801068c8:	c3                   	ret    

801068c9 <sys_exec>:

int
sys_exec(void)
{
801068c9:	f3 0f 1e fb          	endbr32 
801068cd:	55                   	push   %ebp
801068ce:	89 e5                	mov    %esp,%ebp
801068d0:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801068d6:	83 ec 08             	sub    $0x8,%esp
801068d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068dc:	50                   	push   %eax
801068dd:	6a 00                	push   $0x0
801068df:	e8 58 f3 ff ff       	call   80105c3c <argstr>
801068e4:	83 c4 10             	add    $0x10,%esp
801068e7:	85 c0                	test   %eax,%eax
801068e9:	78 18                	js     80106903 <sys_exec+0x3a>
801068eb:	83 ec 08             	sub    $0x8,%esp
801068ee:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801068f4:	50                   	push   %eax
801068f5:	6a 01                	push   $0x1
801068f7:	e8 a3 f2 ff ff       	call   80105b9f <argint>
801068fc:	83 c4 10             	add    $0x10,%esp
801068ff:	85 c0                	test   %eax,%eax
80106901:	79 0a                	jns    8010690d <sys_exec+0x44>
    return -1;
80106903:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106908:	e9 c6 00 00 00       	jmp    801069d3 <sys_exec+0x10a>
  }
  memset(argv, 0, sizeof(argv));
8010690d:	83 ec 04             	sub    $0x4,%esp
80106910:	68 80 00 00 00       	push   $0x80
80106915:	6a 00                	push   $0x0
80106917:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010691d:	50                   	push   %eax
8010691e:	e8 28 ef ff ff       	call   8010584b <memset>
80106923:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106926:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
8010692d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106930:	83 f8 1f             	cmp    $0x1f,%eax
80106933:	76 0a                	jbe    8010693f <sys_exec+0x76>
      return -1;
80106935:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010693a:	e9 94 00 00 00       	jmp    801069d3 <sys_exec+0x10a>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010693f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106942:	c1 e0 02             	shl    $0x2,%eax
80106945:	89 c2                	mov    %eax,%edx
80106947:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010694d:	01 c2                	add    %eax,%edx
8010694f:	83 ec 08             	sub    $0x8,%esp
80106952:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106958:	50                   	push   %eax
80106959:	52                   	push   %edx
8010695a:	e8 95 f1 ff ff       	call   80105af4 <fetchint>
8010695f:	83 c4 10             	add    $0x10,%esp
80106962:	85 c0                	test   %eax,%eax
80106964:	79 07                	jns    8010696d <sys_exec+0xa4>
      return -1;
80106966:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010696b:	eb 66                	jmp    801069d3 <sys_exec+0x10a>
    if(uarg == 0){
8010696d:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106973:	85 c0                	test   %eax,%eax
80106975:	75 27                	jne    8010699e <sys_exec+0xd5>
      argv[i] = 0;
80106977:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010697a:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106981:	00 00 00 00 
      break;
80106985:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106986:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106989:	83 ec 08             	sub    $0x8,%esp
8010698c:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106992:	52                   	push   %edx
80106993:	50                   	push   %eax
80106994:	e8 97 a2 ff ff       	call   80100c30 <exec>
80106999:	83 c4 10             	add    $0x10,%esp
8010699c:	eb 35                	jmp    801069d3 <sys_exec+0x10a>
    if(fetchstr(uarg, &argv[i]) < 0)
8010699e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801069a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801069a7:	c1 e2 02             	shl    $0x2,%edx
801069aa:	01 c2                	add    %eax,%edx
801069ac:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801069b2:	83 ec 08             	sub    $0x8,%esp
801069b5:	52                   	push   %edx
801069b6:	50                   	push   %eax
801069b7:	e8 7b f1 ff ff       	call   80105b37 <fetchstr>
801069bc:	83 c4 10             	add    $0x10,%esp
801069bf:	85 c0                	test   %eax,%eax
801069c1:	79 07                	jns    801069ca <sys_exec+0x101>
      return -1;
801069c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069c8:	eb 09                	jmp    801069d3 <sys_exec+0x10a>
  for(i=0;; i++){
801069ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
801069ce:	e9 5a ff ff ff       	jmp    8010692d <sys_exec+0x64>
}
801069d3:	c9                   	leave  
801069d4:	c3                   	ret    

801069d5 <sys_pipe>:

int
sys_pipe(void)
{
801069d5:	f3 0f 1e fb          	endbr32 
801069d9:	55                   	push   %ebp
801069da:	89 e5                	mov    %esp,%ebp
801069dc:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801069df:	83 ec 04             	sub    $0x4,%esp
801069e2:	6a 08                	push   $0x8
801069e4:	8d 45 ec             	lea    -0x14(%ebp),%eax
801069e7:	50                   	push   %eax
801069e8:	6a 00                	push   $0x0
801069ea:	e8 e1 f1 ff ff       	call   80105bd0 <argptr>
801069ef:	83 c4 10             	add    $0x10,%esp
801069f2:	85 c0                	test   %eax,%eax
801069f4:	79 0a                	jns    80106a00 <sys_pipe+0x2b>
    return -1;
801069f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069fb:	e9 ae 00 00 00       	jmp    80106aae <sys_pipe+0xd9>
  if(pipealloc(&rf, &wf) < 0)
80106a00:	83 ec 08             	sub    $0x8,%esp
80106a03:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106a06:	50                   	push   %eax
80106a07:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106a0a:	50                   	push   %eax
80106a0b:	e8 cd d5 ff ff       	call   80103fdd <pipealloc>
80106a10:	83 c4 10             	add    $0x10,%esp
80106a13:	85 c0                	test   %eax,%eax
80106a15:	79 0a                	jns    80106a21 <sys_pipe+0x4c>
    return -1;
80106a17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a1c:	e9 8d 00 00 00       	jmp    80106aae <sys_pipe+0xd9>
  fd0 = -1;
80106a21:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106a28:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106a2b:	83 ec 0c             	sub    $0xc,%esp
80106a2e:	50                   	push   %eax
80106a2f:	e8 3d f3 ff ff       	call   80105d71 <fdalloc>
80106a34:	83 c4 10             	add    $0x10,%esp
80106a37:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106a3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a3e:	78 18                	js     80106a58 <sys_pipe+0x83>
80106a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a43:	83 ec 0c             	sub    $0xc,%esp
80106a46:	50                   	push   %eax
80106a47:	e8 25 f3 ff ff       	call   80105d71 <fdalloc>
80106a4c:	83 c4 10             	add    $0x10,%esp
80106a4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106a52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106a56:	79 3e                	jns    80106a96 <sys_pipe+0xc1>
    if(fd0 >= 0)
80106a58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a5c:	78 13                	js     80106a71 <sys_pipe+0x9c>
      myproc()->ofile[fd0] = 0;
80106a5e:	e8 f3 da ff ff       	call   80104556 <myproc>
80106a63:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a66:	83 c2 08             	add    $0x8,%edx
80106a69:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106a70:	00 
    fileclose(rf);
80106a71:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106a74:	83 ec 0c             	sub    $0xc,%esp
80106a77:	50                   	push   %eax
80106a78:	e8 31 a7 ff ff       	call   801011ae <fileclose>
80106a7d:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80106a80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a83:	83 ec 0c             	sub    $0xc,%esp
80106a86:	50                   	push   %eax
80106a87:	e8 22 a7 ff ff       	call   801011ae <fileclose>
80106a8c:	83 c4 10             	add    $0x10,%esp
    return -1;
80106a8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a94:	eb 18                	jmp    80106aae <sys_pipe+0xd9>
  }
  fd[0] = fd0;
80106a96:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106a99:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a9c:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106a9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106aa1:	8d 50 04             	lea    0x4(%eax),%edx
80106aa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106aa7:	89 02                	mov    %eax,(%edx)
  return 0;
80106aa9:	b8 00 00 00 00       	mov    $0x0,%eax
80106aae:	c9                   	leave  
80106aaf:	c3                   	ret    

80106ab0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106ab0:	f3 0f 1e fb          	endbr32 
80106ab4:	55                   	push   %ebp
80106ab5:	89 e5                	mov    %esp,%ebp
80106ab7:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106aba:	e8 58 df ff ff       	call   80104a17 <fork>
}
80106abf:	c9                   	leave  
80106ac0:	c3                   	ret    

80106ac1 <sys_exit>:

int
sys_exit(void)
{
80106ac1:	f3 0f 1e fb          	endbr32 
80106ac5:	55                   	push   %ebp
80106ac6:	89 e5                	mov    %esp,%ebp
80106ac8:	83 ec 08             	sub    $0x8,%esp
  exit();
80106acb:	e8 18 e2 ff ff       	call   80104ce8 <exit>
  return 0;  // not reached
80106ad0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106ad5:	c9                   	leave  
80106ad6:	c3                   	ret    

80106ad7 <sys_wait>:

int
sys_wait(void)
{
80106ad7:	f3 0f 1e fb          	endbr32 
80106adb:	55                   	push   %ebp
80106adc:	89 e5                	mov    %esp,%ebp
80106ade:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106ae1:	e8 29 e3 ff ff       	call   80104e0f <wait>
}
80106ae6:	c9                   	leave  
80106ae7:	c3                   	ret    

80106ae8 <sys_kill>:

int
sys_kill(void)
{
80106ae8:	f3 0f 1e fb          	endbr32 
80106aec:	55                   	push   %ebp
80106aed:	89 e5                	mov    %esp,%ebp
80106aef:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106af2:	83 ec 08             	sub    $0x8,%esp
80106af5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106af8:	50                   	push   %eax
80106af9:	6a 00                	push   $0x0
80106afb:	e8 9f f0 ff ff       	call   80105b9f <argint>
80106b00:	83 c4 10             	add    $0x10,%esp
80106b03:	85 c0                	test   %eax,%eax
80106b05:	79 07                	jns    80106b0e <sys_kill+0x26>
    return -1;
80106b07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b0c:	eb 0f                	jmp    80106b1d <sys_kill+0x35>
  return kill(pid);
80106b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b11:	83 ec 0c             	sub    $0xc,%esp
80106b14:	50                   	push   %eax
80106b15:	e8 4d e7 ff ff       	call   80105267 <kill>
80106b1a:	83 c4 10             	add    $0x10,%esp
}
80106b1d:	c9                   	leave  
80106b1e:	c3                   	ret    

80106b1f <sys_getpid>:

int
sys_getpid(void)
{
80106b1f:	f3 0f 1e fb          	endbr32 
80106b23:	55                   	push   %ebp
80106b24:	89 e5                	mov    %esp,%ebp
80106b26:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106b29:	e8 28 da ff ff       	call   80104556 <myproc>
80106b2e:	8b 40 10             	mov    0x10(%eax),%eax
}
80106b31:	c9                   	leave  
80106b32:	c3                   	ret    

80106b33 <sys_sbrk>:

int
sys_sbrk(void)
{
80106b33:	f3 0f 1e fb          	endbr32 
80106b37:	55                   	push   %ebp
80106b38:	89 e5                	mov    %esp,%ebp
80106b3a:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106b3d:	83 ec 08             	sub    $0x8,%esp
80106b40:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b43:	50                   	push   %eax
80106b44:	6a 00                	push   $0x0
80106b46:	e8 54 f0 ff ff       	call   80105b9f <argint>
80106b4b:	83 c4 10             	add    $0x10,%esp
80106b4e:	85 c0                	test   %eax,%eax
80106b50:	79 07                	jns    80106b59 <sys_sbrk+0x26>
    return -1;
80106b52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b57:	eb 27                	jmp    80106b80 <sys_sbrk+0x4d>
  addr = myproc()->sz;
80106b59:	e8 f8 d9 ff ff       	call   80104556 <myproc>
80106b5e:	8b 00                	mov    (%eax),%eax
80106b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b66:	83 ec 0c             	sub    $0xc,%esp
80106b69:	50                   	push   %eax
80106b6a:	e8 6b dc ff ff       	call   801047da <growproc>
80106b6f:	83 c4 10             	add    $0x10,%esp
80106b72:	85 c0                	test   %eax,%eax
80106b74:	79 07                	jns    80106b7d <sys_sbrk+0x4a>
    return -1;
80106b76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b7b:	eb 03                	jmp    80106b80 <sys_sbrk+0x4d>
  return addr;
80106b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106b80:	c9                   	leave  
80106b81:	c3                   	ret    

80106b82 <sys_sleep>:

int
sys_sleep(void)
{
80106b82:	f3 0f 1e fb          	endbr32 
80106b86:	55                   	push   %ebp
80106b87:	89 e5                	mov    %esp,%ebp
80106b89:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106b8c:	83 ec 08             	sub    $0x8,%esp
80106b8f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b92:	50                   	push   %eax
80106b93:	6a 00                	push   $0x0
80106b95:	e8 05 f0 ff ff       	call   80105b9f <argint>
80106b9a:	83 c4 10             	add    $0x10,%esp
80106b9d:	85 c0                	test   %eax,%eax
80106b9f:	79 07                	jns    80106ba8 <sys_sleep+0x26>
    return -1;
80106ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ba6:	eb 76                	jmp    80106c1e <sys_sleep+0x9c>
  acquire(&tickslock);
80106ba8:	83 ec 0c             	sub    $0xc,%esp
80106bab:	68 00 97 11 80       	push   $0x80119700
80106bb0:	e8 f7 e9 ff ff       	call   801055ac <acquire>
80106bb5:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106bb8:	a1 40 9f 11 80       	mov    0x80119f40,%eax
80106bbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106bc0:	eb 38                	jmp    80106bfa <sys_sleep+0x78>
    if(myproc()->killed){
80106bc2:	e8 8f d9 ff ff       	call   80104556 <myproc>
80106bc7:	8b 40 24             	mov    0x24(%eax),%eax
80106bca:	85 c0                	test   %eax,%eax
80106bcc:	74 17                	je     80106be5 <sys_sleep+0x63>
      release(&tickslock);
80106bce:	83 ec 0c             	sub    $0xc,%esp
80106bd1:	68 00 97 11 80       	push   $0x80119700
80106bd6:	e8 43 ea ff ff       	call   8010561e <release>
80106bdb:	83 c4 10             	add    $0x10,%esp
      return -1;
80106bde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106be3:	eb 39                	jmp    80106c1e <sys_sleep+0x9c>
    }
    sleep(&ticks, &tickslock);
80106be5:	83 ec 08             	sub    $0x8,%esp
80106be8:	68 00 97 11 80       	push   $0x80119700
80106bed:	68 40 9f 11 80       	push   $0x80119f40
80106bf2:	e8 43 e5 ff ff       	call   8010513a <sleep>
80106bf7:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80106bfa:	a1 40 9f 11 80       	mov    0x80119f40,%eax
80106bff:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106c02:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106c05:	39 d0                	cmp    %edx,%eax
80106c07:	72 b9                	jb     80106bc2 <sys_sleep+0x40>
  }
  release(&tickslock);
80106c09:	83 ec 0c             	sub    $0xc,%esp
80106c0c:	68 00 97 11 80       	push   $0x80119700
80106c11:	e8 08 ea ff ff       	call   8010561e <release>
80106c16:	83 c4 10             	add    $0x10,%esp
  return 0;
80106c19:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c1e:	c9                   	leave  
80106c1f:	c3                   	ret    

80106c20 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106c20:	f3 0f 1e fb          	endbr32 
80106c24:	55                   	push   %ebp
80106c25:	89 e5                	mov    %esp,%ebp
80106c27:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80106c2a:	83 ec 0c             	sub    $0xc,%esp
80106c2d:	68 00 97 11 80       	push   $0x80119700
80106c32:	e8 75 e9 ff ff       	call   801055ac <acquire>
80106c37:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106c3a:	a1 40 9f 11 80       	mov    0x80119f40,%eax
80106c3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106c42:	83 ec 0c             	sub    $0xc,%esp
80106c45:	68 00 97 11 80       	push   $0x80119700
80106c4a:	e8 cf e9 ff ff       	call   8010561e <release>
80106c4f:	83 c4 10             	add    $0x10,%esp
  return xticks;
80106c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106c55:	c9                   	leave  
80106c56:	c3                   	ret    

80106c57 <sys_mencrypt>:

//changed: added wrapper here
int sys_mencrypt(void) {
80106c57:	f3 0f 1e fb          	endbr32 
80106c5b:	55                   	push   %ebp
80106c5c:	89 e5                	mov    %esp,%ebp
80106c5e:	83 ec 18             	sub    $0x18,%esp
  int len;
  char * virtual_addr;

  if(argint(1, &len) < 0)
80106c61:	83 ec 08             	sub    $0x8,%esp
80106c64:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c67:	50                   	push   %eax
80106c68:	6a 01                	push   $0x1
80106c6a:	e8 30 ef ff ff       	call   80105b9f <argint>
80106c6f:	83 c4 10             	add    $0x10,%esp
80106c72:	85 c0                	test   %eax,%eax
80106c74:	79 07                	jns    80106c7d <sys_mencrypt+0x26>
    return -1;
80106c76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c7b:	eb 50                	jmp    80106ccd <sys_mencrypt+0x76>
  if (len <= 0) {
80106c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c80:	85 c0                	test   %eax,%eax
80106c82:	7f 07                	jg     80106c8b <sys_mencrypt+0x34>
    return -1;
80106c84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c89:	eb 42                	jmp    80106ccd <sys_mencrypt+0x76>
  }
  if(argptr(0, &virtual_addr, 1) < 0)
80106c8b:	83 ec 04             	sub    $0x4,%esp
80106c8e:	6a 01                	push   $0x1
80106c90:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c93:	50                   	push   %eax
80106c94:	6a 00                	push   $0x0
80106c96:	e8 35 ef ff ff       	call   80105bd0 <argptr>
80106c9b:	83 c4 10             	add    $0x10,%esp
80106c9e:	85 c0                	test   %eax,%eax
80106ca0:	79 07                	jns    80106ca9 <sys_mencrypt+0x52>
    return -1;
80106ca2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ca7:	eb 24                	jmp    80106ccd <sys_mencrypt+0x76>
  if ((void *) virtual_addr >= P2V(PHYSTOP)) {
80106ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cac:	3d ff ff ff 8d       	cmp    $0x8dffffff,%eax
80106cb1:	76 07                	jbe    80106cba <sys_mencrypt+0x63>
    return -1;
80106cb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cb8:	eb 13                	jmp    80106ccd <sys_mencrypt+0x76>
  }
  return mencrypt(virtual_addr, len);
80106cba:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cc0:	83 ec 08             	sub    $0x8,%esp
80106cc3:	52                   	push   %edx
80106cc4:	50                   	push   %eax
80106cc5:	e8 20 24 00 00       	call   801090ea <mencrypt>
80106cca:	83 c4 10             	add    $0x10,%esp
}
80106ccd:	c9                   	leave  
80106cce:	c3                   	ret    

80106ccf <sys_getpgtable>:

int sys_getpgtable(void) {
80106ccf:	f3 0f 1e fb          	endbr32 
80106cd3:	55                   	push   %ebp
80106cd4:	89 e5                	mov    %esp,%ebp
80106cd6:	83 ec 18             	sub    $0x18,%esp
  struct pt_entry * entries; 
  int num;
  int wsetOnly;

  if(argint(2, &wsetOnly) < 0)
80106cd9:	83 ec 08             	sub    $0x8,%esp
80106cdc:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106cdf:	50                   	push   %eax
80106ce0:	6a 02                	push   $0x2
80106ce2:	e8 b8 ee ff ff       	call   80105b9f <argint>
80106ce7:	83 c4 10             	add    $0x10,%esp
80106cea:	85 c0                	test   %eax,%eax
80106cec:	79 07                	jns    80106cf5 <sys_getpgtable+0x26>
    return -1;
80106cee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cf3:	eb 56                	jmp    80106d4b <sys_getpgtable+0x7c>
  if(argint(1, &num) < 0)
80106cf5:	83 ec 08             	sub    $0x8,%esp
80106cf8:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106cfb:	50                   	push   %eax
80106cfc:	6a 01                	push   $0x1
80106cfe:	e8 9c ee ff ff       	call   80105b9f <argint>
80106d03:	83 c4 10             	add    $0x10,%esp
80106d06:	85 c0                	test   %eax,%eax
80106d08:	79 07                	jns    80106d11 <sys_getpgtable+0x42>
    return -1;
80106d0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d0f:	eb 3a                	jmp    80106d4b <sys_getpgtable+0x7c>
  if(argptr(0, (char**)&entries, num*sizeof(struct pt_entry)) < 0){
80106d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d14:	c1 e0 03             	shl    $0x3,%eax
80106d17:	83 ec 04             	sub    $0x4,%esp
80106d1a:	50                   	push   %eax
80106d1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d1e:	50                   	push   %eax
80106d1f:	6a 00                	push   $0x0
80106d21:	e8 aa ee ff ff       	call   80105bd0 <argptr>
80106d26:	83 c4 10             	add    $0x10,%esp
80106d29:	85 c0                	test   %eax,%eax
80106d2b:	79 07                	jns    80106d34 <sys_getpgtable+0x65>
    return -1;
80106d2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d32:	eb 17                	jmp    80106d4b <sys_getpgtable+0x7c>
  }

  return getpgtable(entries, num, wsetOnly);
80106d34:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80106d37:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d3d:	83 ec 04             	sub    $0x4,%esp
80106d40:	51                   	push   %ecx
80106d41:	52                   	push   %edx
80106d42:	50                   	push   %eax
80106d43:	e8 dc 25 00 00       	call   80109324 <getpgtable>
80106d48:	83 c4 10             	add    $0x10,%esp
}
80106d4b:	c9                   	leave  
80106d4c:	c3                   	ret    

80106d4d <sys_dump_rawphymem>:


int sys_dump_rawphymem(void) {
80106d4d:	f3 0f 1e fb          	endbr32 
80106d51:	55                   	push   %ebp
80106d52:	89 e5                	mov    %esp,%ebp
80106d54:	83 ec 18             	sub    $0x18,%esp
  char * physical_addr; 
  char * buffer;

  if(argptr(1, &buffer, PGSIZE) < 0)
80106d57:	83 ec 04             	sub    $0x4,%esp
80106d5a:	68 00 10 00 00       	push   $0x1000
80106d5f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d62:	50                   	push   %eax
80106d63:	6a 01                	push   $0x1
80106d65:	e8 66 ee ff ff       	call   80105bd0 <argptr>
80106d6a:	83 c4 10             	add    $0x10,%esp
80106d6d:	85 c0                	test   %eax,%eax
80106d6f:	79 07                	jns    80106d78 <sys_dump_rawphymem+0x2b>
    return -1;
80106d71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d76:	eb 2f                	jmp    80106da7 <sys_dump_rawphymem+0x5a>
  if(argint(0, (int*)&physical_addr) < 0)
80106d78:	83 ec 08             	sub    $0x8,%esp
80106d7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d7e:	50                   	push   %eax
80106d7f:	6a 00                	push   $0x0
80106d81:	e8 19 ee ff ff       	call   80105b9f <argint>
80106d86:	83 c4 10             	add    $0x10,%esp
80106d89:	85 c0                	test   %eax,%eax
80106d8b:	79 07                	jns    80106d94 <sys_dump_rawphymem+0x47>
    return -1;
80106d8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d92:	eb 13                	jmp    80106da7 <sys_dump_rawphymem+0x5a>
  return dump_rawphymem(physical_addr, buffer);
80106d94:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d9a:	83 ec 08             	sub    $0x8,%esp
80106d9d:	52                   	push   %edx
80106d9e:	50                   	push   %eax
80106d9f:	e8 af 29 00 00       	call   80109753 <dump_rawphymem>
80106da4:	83 c4 10             	add    $0x10,%esp
80106da7:	c9                   	leave  
80106da8:	c3                   	ret    

80106da9 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106da9:	1e                   	push   %ds
  pushl %es
80106daa:	06                   	push   %es
  pushl %fs
80106dab:	0f a0                	push   %fs
  pushl %gs
80106dad:	0f a8                	push   %gs
  pushal
80106daf:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106db0:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106db4:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106db6:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106db8:	54                   	push   %esp
  call trap
80106db9:	e8 df 01 00 00       	call   80106f9d <trap>
  addl $4, %esp
80106dbe:	83 c4 04             	add    $0x4,%esp

80106dc1 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106dc1:	61                   	popa   
  popl %gs
80106dc2:	0f a9                	pop    %gs
  popl %fs
80106dc4:	0f a1                	pop    %fs
  popl %es
80106dc6:	07                   	pop    %es
  popl %ds
80106dc7:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106dc8:	83 c4 08             	add    $0x8,%esp
  iret
80106dcb:	cf                   	iret   

80106dcc <lidt>:
{
80106dcc:	55                   	push   %ebp
80106dcd:	89 e5                	mov    %esp,%ebp
80106dcf:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dd5:	83 e8 01             	sub    $0x1,%eax
80106dd8:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106ddc:	8b 45 08             	mov    0x8(%ebp),%eax
80106ddf:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106de3:	8b 45 08             	mov    0x8(%ebp),%eax
80106de6:	c1 e8 10             	shr    $0x10,%eax
80106de9:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106ded:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106df0:	0f 01 18             	lidtl  (%eax)
}
80106df3:	90                   	nop
80106df4:	c9                   	leave  
80106df5:	c3                   	ret    

80106df6 <rcr2>:

static inline uint
rcr2(void)
{
80106df6:	55                   	push   %ebp
80106df7:	89 e5                	mov    %esp,%ebp
80106df9:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106dfc:	0f 20 d0             	mov    %cr2,%eax
80106dff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106e02:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106e05:	c9                   	leave  
80106e06:	c3                   	ret    

80106e07 <tvinit>:
extern uint vectors[]; // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void)
{
80106e07:	f3 0f 1e fb          	endbr32 
80106e0b:	55                   	push   %ebp
80106e0c:	89 e5                	mov    %esp,%ebp
80106e0e:	83 ec 18             	sub    $0x18,%esp
  int i;

  for (i = 0; i < 256; i++)
80106e11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106e18:	e9 c3 00 00 00       	jmp    80106ee0 <tvinit+0xd9>
    SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80106e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e20:	8b 04 85 84 d0 10 80 	mov    -0x7fef2f7c(,%eax,4),%eax
80106e27:	89 c2                	mov    %eax,%edx
80106e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e2c:	66 89 14 c5 40 97 11 	mov    %dx,-0x7fee68c0(,%eax,8)
80106e33:	80 
80106e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e37:	66 c7 04 c5 42 97 11 	movw   $0x8,-0x7fee68be(,%eax,8)
80106e3e:	80 08 00 
80106e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e44:	0f b6 14 c5 44 97 11 	movzbl -0x7fee68bc(,%eax,8),%edx
80106e4b:	80 
80106e4c:	83 e2 e0             	and    $0xffffffe0,%edx
80106e4f:	88 14 c5 44 97 11 80 	mov    %dl,-0x7fee68bc(,%eax,8)
80106e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e59:	0f b6 14 c5 44 97 11 	movzbl -0x7fee68bc(,%eax,8),%edx
80106e60:	80 
80106e61:	83 e2 1f             	and    $0x1f,%edx
80106e64:	88 14 c5 44 97 11 80 	mov    %dl,-0x7fee68bc(,%eax,8)
80106e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e6e:	0f b6 14 c5 45 97 11 	movzbl -0x7fee68bb(,%eax,8),%edx
80106e75:	80 
80106e76:	83 e2 f0             	and    $0xfffffff0,%edx
80106e79:	83 ca 0e             	or     $0xe,%edx
80106e7c:	88 14 c5 45 97 11 80 	mov    %dl,-0x7fee68bb(,%eax,8)
80106e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e86:	0f b6 14 c5 45 97 11 	movzbl -0x7fee68bb(,%eax,8),%edx
80106e8d:	80 
80106e8e:	83 e2 ef             	and    $0xffffffef,%edx
80106e91:	88 14 c5 45 97 11 80 	mov    %dl,-0x7fee68bb(,%eax,8)
80106e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e9b:	0f b6 14 c5 45 97 11 	movzbl -0x7fee68bb(,%eax,8),%edx
80106ea2:	80 
80106ea3:	83 e2 9f             	and    $0xffffff9f,%edx
80106ea6:	88 14 c5 45 97 11 80 	mov    %dl,-0x7fee68bb(,%eax,8)
80106ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106eb0:	0f b6 14 c5 45 97 11 	movzbl -0x7fee68bb(,%eax,8),%edx
80106eb7:	80 
80106eb8:	83 ca 80             	or     $0xffffff80,%edx
80106ebb:	88 14 c5 45 97 11 80 	mov    %dl,-0x7fee68bb(,%eax,8)
80106ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ec5:	8b 04 85 84 d0 10 80 	mov    -0x7fef2f7c(,%eax,4),%eax
80106ecc:	c1 e8 10             	shr    $0x10,%eax
80106ecf:	89 c2                	mov    %eax,%edx
80106ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ed4:	66 89 14 c5 46 97 11 	mov    %dx,-0x7fee68ba(,%eax,8)
80106edb:	80 
  for (i = 0; i < 256; i++)
80106edc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106ee0:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106ee7:	0f 8e 30 ff ff ff    	jle    80106e1d <tvinit+0x16>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80106eed:	a1 84 d1 10 80       	mov    0x8010d184,%eax
80106ef2:	66 a3 40 99 11 80    	mov    %ax,0x80119940
80106ef8:	66 c7 05 42 99 11 80 	movw   $0x8,0x80119942
80106eff:	08 00 
80106f01:	0f b6 05 44 99 11 80 	movzbl 0x80119944,%eax
80106f08:	83 e0 e0             	and    $0xffffffe0,%eax
80106f0b:	a2 44 99 11 80       	mov    %al,0x80119944
80106f10:	0f b6 05 44 99 11 80 	movzbl 0x80119944,%eax
80106f17:	83 e0 1f             	and    $0x1f,%eax
80106f1a:	a2 44 99 11 80       	mov    %al,0x80119944
80106f1f:	0f b6 05 45 99 11 80 	movzbl 0x80119945,%eax
80106f26:	83 c8 0f             	or     $0xf,%eax
80106f29:	a2 45 99 11 80       	mov    %al,0x80119945
80106f2e:	0f b6 05 45 99 11 80 	movzbl 0x80119945,%eax
80106f35:	83 e0 ef             	and    $0xffffffef,%eax
80106f38:	a2 45 99 11 80       	mov    %al,0x80119945
80106f3d:	0f b6 05 45 99 11 80 	movzbl 0x80119945,%eax
80106f44:	83 c8 60             	or     $0x60,%eax
80106f47:	a2 45 99 11 80       	mov    %al,0x80119945
80106f4c:	0f b6 05 45 99 11 80 	movzbl 0x80119945,%eax
80106f53:	83 c8 80             	or     $0xffffff80,%eax
80106f56:	a2 45 99 11 80       	mov    %al,0x80119945
80106f5b:	a1 84 d1 10 80       	mov    0x8010d184,%eax
80106f60:	c1 e8 10             	shr    $0x10,%eax
80106f63:	66 a3 46 99 11 80    	mov    %ax,0x80119946

  initlock(&tickslock, "time");
80106f69:	83 ec 08             	sub    $0x8,%esp
80106f6c:	68 04 9d 10 80       	push   $0x80109d04
80106f71:	68 00 97 11 80       	push   $0x80119700
80106f76:	e8 0b e6 ff ff       	call   80105586 <initlock>
80106f7b:	83 c4 10             	add    $0x10,%esp
}
80106f7e:	90                   	nop
80106f7f:	c9                   	leave  
80106f80:	c3                   	ret    

80106f81 <idtinit>:

void idtinit(void)
{
80106f81:	f3 0f 1e fb          	endbr32 
80106f85:	55                   	push   %ebp
80106f86:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106f88:	68 00 08 00 00       	push   $0x800
80106f8d:	68 40 97 11 80       	push   $0x80119740
80106f92:	e8 35 fe ff ff       	call   80106dcc <lidt>
80106f97:	83 c4 08             	add    $0x8,%esp
}
80106f9a:	90                   	nop
80106f9b:	c9                   	leave  
80106f9c:	c3                   	ret    

80106f9d <trap>:

// PAGEBREAK: 41
void trap(struct trapframe *tf)
{
80106f9d:	f3 0f 1e fb          	endbr32 
80106fa1:	55                   	push   %ebp
80106fa2:	89 e5                	mov    %esp,%ebp
80106fa4:	57                   	push   %edi
80106fa5:	56                   	push   %esi
80106fa6:	53                   	push   %ebx
80106fa7:	83 ec 2c             	sub    $0x2c,%esp
  if (tf->trapno == T_SYSCALL)
80106faa:	8b 45 08             	mov    0x8(%ebp),%eax
80106fad:	8b 40 30             	mov    0x30(%eax),%eax
80106fb0:	83 f8 40             	cmp    $0x40,%eax
80106fb3:	75 3b                	jne    80106ff0 <trap+0x53>
  {
    if (myproc()->killed)
80106fb5:	e8 9c d5 ff ff       	call   80104556 <myproc>
80106fba:	8b 40 24             	mov    0x24(%eax),%eax
80106fbd:	85 c0                	test   %eax,%eax
80106fbf:	74 05                	je     80106fc6 <trap+0x29>
      exit();
80106fc1:	e8 22 dd ff ff       	call   80104ce8 <exit>
    myproc()->tf = tf;
80106fc6:	e8 8b d5 ff ff       	call   80104556 <myproc>
80106fcb:	8b 55 08             	mov    0x8(%ebp),%edx
80106fce:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106fd1:	e8 a1 ec ff ff       	call   80105c77 <syscall>
    if (myproc()->killed)
80106fd6:	e8 7b d5 ff ff       	call   80104556 <myproc>
80106fdb:	8b 40 24             	mov    0x24(%eax),%eax
80106fde:	85 c0                	test   %eax,%eax
80106fe0:	0f 84 38 02 00 00    	je     8010721e <trap+0x281>
      exit();
80106fe6:	e8 fd dc ff ff       	call   80104ce8 <exit>
    return;
80106feb:	e9 2e 02 00 00       	jmp    8010721e <trap+0x281>
  }
  char *addr;
  switch (tf->trapno)
80106ff0:	8b 45 08             	mov    0x8(%ebp),%eax
80106ff3:	8b 40 30             	mov    0x30(%eax),%eax
80106ff6:	83 e8 0e             	sub    $0xe,%eax
80106ff9:	83 f8 31             	cmp    $0x31,%eax
80106ffc:	0f 87 e4 00 00 00    	ja     801070e6 <trap+0x149>
80107002:	8b 04 85 c4 9d 10 80 	mov    -0x7fef623c(,%eax,4),%eax
80107009:	3e ff e0             	notrack jmp *%eax
  {
  case T_IRQ0 + IRQ_TIMER:
    if (cpuid() == 0)
8010700c:	e8 aa d4 ff ff       	call   801044bb <cpuid>
80107011:	85 c0                	test   %eax,%eax
80107013:	75 3d                	jne    80107052 <trap+0xb5>
    {
      acquire(&tickslock);
80107015:	83 ec 0c             	sub    $0xc,%esp
80107018:	68 00 97 11 80       	push   $0x80119700
8010701d:	e8 8a e5 ff ff       	call   801055ac <acquire>
80107022:	83 c4 10             	add    $0x10,%esp
      ticks++;
80107025:	a1 40 9f 11 80       	mov    0x80119f40,%eax
8010702a:	83 c0 01             	add    $0x1,%eax
8010702d:	a3 40 9f 11 80       	mov    %eax,0x80119f40
      wakeup(&ticks);
80107032:	83 ec 0c             	sub    $0xc,%esp
80107035:	68 40 9f 11 80       	push   $0x80119f40
8010703a:	e8 ed e1 ff ff       	call   8010522c <wakeup>
8010703f:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80107042:	83 ec 0c             	sub    $0xc,%esp
80107045:	68 00 97 11 80       	push   $0x80119700
8010704a:	e8 cf e5 ff ff       	call   8010561e <release>
8010704f:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80107052:	e8 5a c1 ff ff       	call   801031b1 <lapiceoi>
    break;
80107057:	e9 42 01 00 00       	jmp    8010719e <trap+0x201>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
8010705c:	e8 85 b9 ff ff       	call   801029e6 <ideintr>
    lapiceoi();
80107061:	e8 4b c1 ff ff       	call   801031b1 <lapiceoi>
    break;
80107066:	e9 33 01 00 00       	jmp    8010719e <trap+0x201>
  case T_IRQ0 + IRQ_IDE + 1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
8010706b:	e8 77 bf ff ff       	call   80102fe7 <kbdintr>
    lapiceoi();
80107070:	e8 3c c1 ff ff       	call   801031b1 <lapiceoi>
    break;
80107075:	e9 24 01 00 00       	jmp    8010719e <trap+0x201>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
8010707a:	e8 81 03 00 00       	call   80107400 <uartintr>
    lapiceoi();
8010707f:	e8 2d c1 ff ff       	call   801031b1 <lapiceoi>
    break;
80107084:	e9 15 01 00 00       	jmp    8010719e <trap+0x201>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107089:	8b 45 08             	mov    0x8(%ebp),%eax
8010708c:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
8010708f:	8b 45 08             	mov    0x8(%ebp),%eax
80107092:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107096:	0f b7 d8             	movzwl %ax,%ebx
80107099:	e8 1d d4 ff ff       	call   801044bb <cpuid>
8010709e:	56                   	push   %esi
8010709f:	53                   	push   %ebx
801070a0:	50                   	push   %eax
801070a1:	68 0c 9d 10 80       	push   $0x80109d0c
801070a6:	e8 6d 93 ff ff       	call   80100418 <cprintf>
801070ab:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801070ae:	e8 fe c0 ff ff       	call   801031b1 <lapiceoi>
    break;
801070b3:	e9 e6 00 00 00       	jmp    8010719e <trap+0x201>
  case T_PGFLT:
    // Food for thought: How can one distinguish between a regular page fault and a decryption request? If its encrypted bit is set? - spilde answer
    cprintf("p4Debug : Page fault !\n");
801070b8:	83 ec 0c             	sub    $0xc,%esp
801070bb:	68 30 9d 10 80       	push   $0x80109d30
801070c0:	e8 53 93 ff ff       	call   80100418 <cprintf>
801070c5:	83 c4 10             	add    $0x10,%esp
    addr = (char *)rcr2();
801070c8:	e8 29 fd ff ff       	call   80106df6 <rcr2>
801070cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    if (!mdecrypt(addr))
801070d0:	83 ec 0c             	sub    $0xc,%esp
801070d3:	ff 75 e4             	pushl  -0x1c(%ebp)
801070d6:	e8 1e 1c 00 00       	call   80108cf9 <mdecrypt>
801070db:	83 c4 10             	add    $0x10,%esp
801070de:	85 c0                	test   %eax,%eax
801070e0:	0f 84 b7 00 00 00    	je     8010719d <trap+0x200>
    };

    // break;
  // PAGEBREAK: 13
  default:
    if (myproc() == 0 || (tf->cs & 3) == 0)
801070e6:	e8 6b d4 ff ff       	call   80104556 <myproc>
801070eb:	85 c0                	test   %eax,%eax
801070ed:	74 11                	je     80107100 <trap+0x163>
801070ef:	8b 45 08             	mov    0x8(%ebp),%eax
801070f2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801070f6:	0f b7 c0             	movzwl %ax,%eax
801070f9:	83 e0 03             	and    $0x3,%eax
801070fc:	85 c0                	test   %eax,%eax
801070fe:	75 39                	jne    80107139 <trap+0x19c>
    {
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107100:	e8 f1 fc ff ff       	call   80106df6 <rcr2>
80107105:	89 c3                	mov    %eax,%ebx
80107107:	8b 45 08             	mov    0x8(%ebp),%eax
8010710a:	8b 70 38             	mov    0x38(%eax),%esi
8010710d:	e8 a9 d3 ff ff       	call   801044bb <cpuid>
80107112:	8b 55 08             	mov    0x8(%ebp),%edx
80107115:	8b 52 30             	mov    0x30(%edx),%edx
80107118:	83 ec 0c             	sub    $0xc,%esp
8010711b:	53                   	push   %ebx
8010711c:	56                   	push   %esi
8010711d:	50                   	push   %eax
8010711e:	52                   	push   %edx
8010711f:	68 48 9d 10 80       	push   $0x80109d48
80107124:	e8 ef 92 ff ff       	call   80100418 <cprintf>
80107129:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
8010712c:	83 ec 0c             	sub    $0xc,%esp
8010712f:	68 7a 9d 10 80       	push   $0x80109d7a
80107134:	e8 cf 94 ff ff       	call   80100608 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107139:	e8 b8 fc ff ff       	call   80106df6 <rcr2>
8010713e:	89 c6                	mov    %eax,%esi
80107140:	8b 45 08             	mov    0x8(%ebp),%eax
80107143:	8b 40 38             	mov    0x38(%eax),%eax
80107146:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80107149:	e8 6d d3 ff ff       	call   801044bb <cpuid>
8010714e:	89 c3                	mov    %eax,%ebx
80107150:	8b 45 08             	mov    0x8(%ebp),%eax
80107153:	8b 48 34             	mov    0x34(%eax),%ecx
80107156:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80107159:	8b 45 08             	mov    0x8(%ebp),%eax
8010715c:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010715f:	e8 f2 d3 ff ff       	call   80104556 <myproc>
80107164:	8d 50 6c             	lea    0x6c(%eax),%edx
80107167:	89 55 cc             	mov    %edx,-0x34(%ebp)
8010716a:	e8 e7 d3 ff ff       	call   80104556 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010716f:	8b 40 10             	mov    0x10(%eax),%eax
80107172:	56                   	push   %esi
80107173:	ff 75 d4             	pushl  -0x2c(%ebp)
80107176:	53                   	push   %ebx
80107177:	ff 75 d0             	pushl  -0x30(%ebp)
8010717a:	57                   	push   %edi
8010717b:	ff 75 cc             	pushl  -0x34(%ebp)
8010717e:	50                   	push   %eax
8010717f:	68 80 9d 10 80       	push   $0x80109d80
80107184:	e8 8f 92 ff ff       	call   80100418 <cprintf>
80107189:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010718c:	e8 c5 d3 ff ff       	call   80104556 <myproc>
80107191:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107198:	eb 04                	jmp    8010719e <trap+0x201>
    break;
8010719a:	90                   	nop
8010719b:	eb 01                	jmp    8010719e <trap+0x201>
      break;
8010719d:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
8010719e:	e8 b3 d3 ff ff       	call   80104556 <myproc>
801071a3:	85 c0                	test   %eax,%eax
801071a5:	74 23                	je     801071ca <trap+0x22d>
801071a7:	e8 aa d3 ff ff       	call   80104556 <myproc>
801071ac:	8b 40 24             	mov    0x24(%eax),%eax
801071af:	85 c0                	test   %eax,%eax
801071b1:	74 17                	je     801071ca <trap+0x22d>
801071b3:	8b 45 08             	mov    0x8(%ebp),%eax
801071b6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801071ba:	0f b7 c0             	movzwl %ax,%eax
801071bd:	83 e0 03             	and    $0x3,%eax
801071c0:	83 f8 03             	cmp    $0x3,%eax
801071c3:	75 05                	jne    801071ca <trap+0x22d>
    exit();
801071c5:	e8 1e db ff ff       	call   80104ce8 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if (myproc() && myproc()->state == RUNNING &&
801071ca:	e8 87 d3 ff ff       	call   80104556 <myproc>
801071cf:	85 c0                	test   %eax,%eax
801071d1:	74 1d                	je     801071f0 <trap+0x253>
801071d3:	e8 7e d3 ff ff       	call   80104556 <myproc>
801071d8:	8b 40 0c             	mov    0xc(%eax),%eax
801071db:	83 f8 04             	cmp    $0x4,%eax
801071de:	75 10                	jne    801071f0 <trap+0x253>
      tf->trapno == T_IRQ0 + IRQ_TIMER)
801071e0:	8b 45 08             	mov    0x8(%ebp),%eax
801071e3:	8b 40 30             	mov    0x30(%eax),%eax
  if (myproc() && myproc()->state == RUNNING &&
801071e6:	83 f8 20             	cmp    $0x20,%eax
801071e9:	75 05                	jne    801071f0 <trap+0x253>
    yield();
801071eb:	e8 c2 de ff ff       	call   801050b2 <yield>

  // Check if the process has been killed since we yielded
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801071f0:	e8 61 d3 ff ff       	call   80104556 <myproc>
801071f5:	85 c0                	test   %eax,%eax
801071f7:	74 26                	je     8010721f <trap+0x282>
801071f9:	e8 58 d3 ff ff       	call   80104556 <myproc>
801071fe:	8b 40 24             	mov    0x24(%eax),%eax
80107201:	85 c0                	test   %eax,%eax
80107203:	74 1a                	je     8010721f <trap+0x282>
80107205:	8b 45 08             	mov    0x8(%ebp),%eax
80107208:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010720c:	0f b7 c0             	movzwl %ax,%eax
8010720f:	83 e0 03             	and    $0x3,%eax
80107212:	83 f8 03             	cmp    $0x3,%eax
80107215:	75 08                	jne    8010721f <trap+0x282>
    exit();
80107217:	e8 cc da ff ff       	call   80104ce8 <exit>
8010721c:	eb 01                	jmp    8010721f <trap+0x282>
    return;
8010721e:	90                   	nop
}
8010721f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107222:	5b                   	pop    %ebx
80107223:	5e                   	pop    %esi
80107224:	5f                   	pop    %edi
80107225:	5d                   	pop    %ebp
80107226:	c3                   	ret    

80107227 <inb>:
{
80107227:	55                   	push   %ebp
80107228:	89 e5                	mov    %esp,%ebp
8010722a:	83 ec 14             	sub    $0x14,%esp
8010722d:	8b 45 08             	mov    0x8(%ebp),%eax
80107230:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107234:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107238:	89 c2                	mov    %eax,%edx
8010723a:	ec                   	in     (%dx),%al
8010723b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010723e:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107242:	c9                   	leave  
80107243:	c3                   	ret    

80107244 <outb>:
{
80107244:	55                   	push   %ebp
80107245:	89 e5                	mov    %esp,%ebp
80107247:	83 ec 08             	sub    $0x8,%esp
8010724a:	8b 45 08             	mov    0x8(%ebp),%eax
8010724d:	8b 55 0c             	mov    0xc(%ebp),%edx
80107250:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80107254:	89 d0                	mov    %edx,%eax
80107256:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107259:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010725d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107261:	ee                   	out    %al,(%dx)
}
80107262:	90                   	nop
80107263:	c9                   	leave  
80107264:	c3                   	ret    

80107265 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107265:	f3 0f 1e fb          	endbr32 
80107269:	55                   	push   %ebp
8010726a:	89 e5                	mov    %esp,%ebp
8010726c:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
8010726f:	6a 00                	push   $0x0
80107271:	68 fa 03 00 00       	push   $0x3fa
80107276:	e8 c9 ff ff ff       	call   80107244 <outb>
8010727b:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
8010727e:	68 80 00 00 00       	push   $0x80
80107283:	68 fb 03 00 00       	push   $0x3fb
80107288:	e8 b7 ff ff ff       	call   80107244 <outb>
8010728d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107290:	6a 0c                	push   $0xc
80107292:	68 f8 03 00 00       	push   $0x3f8
80107297:	e8 a8 ff ff ff       	call   80107244 <outb>
8010729c:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
8010729f:	6a 00                	push   $0x0
801072a1:	68 f9 03 00 00       	push   $0x3f9
801072a6:	e8 99 ff ff ff       	call   80107244 <outb>
801072ab:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801072ae:	6a 03                	push   $0x3
801072b0:	68 fb 03 00 00       	push   $0x3fb
801072b5:	e8 8a ff ff ff       	call   80107244 <outb>
801072ba:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
801072bd:	6a 00                	push   $0x0
801072bf:	68 fc 03 00 00       	push   $0x3fc
801072c4:	e8 7b ff ff ff       	call   80107244 <outb>
801072c9:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801072cc:	6a 01                	push   $0x1
801072ce:	68 f9 03 00 00       	push   $0x3f9
801072d3:	e8 6c ff ff ff       	call   80107244 <outb>
801072d8:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801072db:	68 fd 03 00 00       	push   $0x3fd
801072e0:	e8 42 ff ff ff       	call   80107227 <inb>
801072e5:	83 c4 04             	add    $0x4,%esp
801072e8:	3c ff                	cmp    $0xff,%al
801072ea:	74 61                	je     8010734d <uartinit+0xe8>
    return;
  uart = 1;
801072ec:	c7 05 44 d6 10 80 01 	movl   $0x1,0x8010d644
801072f3:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801072f6:	68 fa 03 00 00       	push   $0x3fa
801072fb:	e8 27 ff ff ff       	call   80107227 <inb>
80107300:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80107303:	68 f8 03 00 00       	push   $0x3f8
80107308:	e8 1a ff ff ff       	call   80107227 <inb>
8010730d:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
80107310:	83 ec 08             	sub    $0x8,%esp
80107313:	6a 00                	push   $0x0
80107315:	6a 04                	push   $0x4
80107317:	e8 7c b9 ff ff       	call   80102c98 <ioapicenable>
8010731c:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010731f:	c7 45 f4 8c 9e 10 80 	movl   $0x80109e8c,-0xc(%ebp)
80107326:	eb 19                	jmp    80107341 <uartinit+0xdc>
    uartputc(*p);
80107328:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010732b:	0f b6 00             	movzbl (%eax),%eax
8010732e:	0f be c0             	movsbl %al,%eax
80107331:	83 ec 0c             	sub    $0xc,%esp
80107334:	50                   	push   %eax
80107335:	e8 16 00 00 00       	call   80107350 <uartputc>
8010733a:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
8010733d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107341:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107344:	0f b6 00             	movzbl (%eax),%eax
80107347:	84 c0                	test   %al,%al
80107349:	75 dd                	jne    80107328 <uartinit+0xc3>
8010734b:	eb 01                	jmp    8010734e <uartinit+0xe9>
    return;
8010734d:	90                   	nop
}
8010734e:	c9                   	leave  
8010734f:	c3                   	ret    

80107350 <uartputc>:

void
uartputc(int c)
{
80107350:	f3 0f 1e fb          	endbr32 
80107354:	55                   	push   %ebp
80107355:	89 e5                	mov    %esp,%ebp
80107357:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
8010735a:	a1 44 d6 10 80       	mov    0x8010d644,%eax
8010735f:	85 c0                	test   %eax,%eax
80107361:	74 53                	je     801073b6 <uartputc+0x66>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107363:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010736a:	eb 11                	jmp    8010737d <uartputc+0x2d>
    microdelay(10);
8010736c:	83 ec 0c             	sub    $0xc,%esp
8010736f:	6a 0a                	push   $0xa
80107371:	e8 5a be ff ff       	call   801031d0 <microdelay>
80107376:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107379:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010737d:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107381:	7f 1a                	jg     8010739d <uartputc+0x4d>
80107383:	83 ec 0c             	sub    $0xc,%esp
80107386:	68 fd 03 00 00       	push   $0x3fd
8010738b:	e8 97 fe ff ff       	call   80107227 <inb>
80107390:	83 c4 10             	add    $0x10,%esp
80107393:	0f b6 c0             	movzbl %al,%eax
80107396:	83 e0 20             	and    $0x20,%eax
80107399:	85 c0                	test   %eax,%eax
8010739b:	74 cf                	je     8010736c <uartputc+0x1c>
  outb(COM1+0, c);
8010739d:	8b 45 08             	mov    0x8(%ebp),%eax
801073a0:	0f b6 c0             	movzbl %al,%eax
801073a3:	83 ec 08             	sub    $0x8,%esp
801073a6:	50                   	push   %eax
801073a7:	68 f8 03 00 00       	push   $0x3f8
801073ac:	e8 93 fe ff ff       	call   80107244 <outb>
801073b1:	83 c4 10             	add    $0x10,%esp
801073b4:	eb 01                	jmp    801073b7 <uartputc+0x67>
    return;
801073b6:	90                   	nop
}
801073b7:	c9                   	leave  
801073b8:	c3                   	ret    

801073b9 <uartgetc>:

static int
uartgetc(void)
{
801073b9:	f3 0f 1e fb          	endbr32 
801073bd:	55                   	push   %ebp
801073be:	89 e5                	mov    %esp,%ebp
  if(!uart)
801073c0:	a1 44 d6 10 80       	mov    0x8010d644,%eax
801073c5:	85 c0                	test   %eax,%eax
801073c7:	75 07                	jne    801073d0 <uartgetc+0x17>
    return -1;
801073c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073ce:	eb 2e                	jmp    801073fe <uartgetc+0x45>
  if(!(inb(COM1+5) & 0x01))
801073d0:	68 fd 03 00 00       	push   $0x3fd
801073d5:	e8 4d fe ff ff       	call   80107227 <inb>
801073da:	83 c4 04             	add    $0x4,%esp
801073dd:	0f b6 c0             	movzbl %al,%eax
801073e0:	83 e0 01             	and    $0x1,%eax
801073e3:	85 c0                	test   %eax,%eax
801073e5:	75 07                	jne    801073ee <uartgetc+0x35>
    return -1;
801073e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073ec:	eb 10                	jmp    801073fe <uartgetc+0x45>
  return inb(COM1+0);
801073ee:	68 f8 03 00 00       	push   $0x3f8
801073f3:	e8 2f fe ff ff       	call   80107227 <inb>
801073f8:	83 c4 04             	add    $0x4,%esp
801073fb:	0f b6 c0             	movzbl %al,%eax
}
801073fe:	c9                   	leave  
801073ff:	c3                   	ret    

80107400 <uartintr>:

void
uartintr(void)
{
80107400:	f3 0f 1e fb          	endbr32 
80107404:	55                   	push   %ebp
80107405:	89 e5                	mov    %esp,%ebp
80107407:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
8010740a:	83 ec 0c             	sub    $0xc,%esp
8010740d:	68 b9 73 10 80       	push   $0x801073b9
80107412:	e8 91 94 ff ff       	call   801008a8 <consoleintr>
80107417:	83 c4 10             	add    $0x10,%esp
}
8010741a:	90                   	nop
8010741b:	c9                   	leave  
8010741c:	c3                   	ret    

8010741d <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010741d:	6a 00                	push   $0x0
  pushl $0
8010741f:	6a 00                	push   $0x0
  jmp alltraps
80107421:	e9 83 f9 ff ff       	jmp    80106da9 <alltraps>

80107426 <vector1>:
.globl vector1
vector1:
  pushl $0
80107426:	6a 00                	push   $0x0
  pushl $1
80107428:	6a 01                	push   $0x1
  jmp alltraps
8010742a:	e9 7a f9 ff ff       	jmp    80106da9 <alltraps>

8010742f <vector2>:
.globl vector2
vector2:
  pushl $0
8010742f:	6a 00                	push   $0x0
  pushl $2
80107431:	6a 02                	push   $0x2
  jmp alltraps
80107433:	e9 71 f9 ff ff       	jmp    80106da9 <alltraps>

80107438 <vector3>:
.globl vector3
vector3:
  pushl $0
80107438:	6a 00                	push   $0x0
  pushl $3
8010743a:	6a 03                	push   $0x3
  jmp alltraps
8010743c:	e9 68 f9 ff ff       	jmp    80106da9 <alltraps>

80107441 <vector4>:
.globl vector4
vector4:
  pushl $0
80107441:	6a 00                	push   $0x0
  pushl $4
80107443:	6a 04                	push   $0x4
  jmp alltraps
80107445:	e9 5f f9 ff ff       	jmp    80106da9 <alltraps>

8010744a <vector5>:
.globl vector5
vector5:
  pushl $0
8010744a:	6a 00                	push   $0x0
  pushl $5
8010744c:	6a 05                	push   $0x5
  jmp alltraps
8010744e:	e9 56 f9 ff ff       	jmp    80106da9 <alltraps>

80107453 <vector6>:
.globl vector6
vector6:
  pushl $0
80107453:	6a 00                	push   $0x0
  pushl $6
80107455:	6a 06                	push   $0x6
  jmp alltraps
80107457:	e9 4d f9 ff ff       	jmp    80106da9 <alltraps>

8010745c <vector7>:
.globl vector7
vector7:
  pushl $0
8010745c:	6a 00                	push   $0x0
  pushl $7
8010745e:	6a 07                	push   $0x7
  jmp alltraps
80107460:	e9 44 f9 ff ff       	jmp    80106da9 <alltraps>

80107465 <vector8>:
.globl vector8
vector8:
  pushl $8
80107465:	6a 08                	push   $0x8
  jmp alltraps
80107467:	e9 3d f9 ff ff       	jmp    80106da9 <alltraps>

8010746c <vector9>:
.globl vector9
vector9:
  pushl $0
8010746c:	6a 00                	push   $0x0
  pushl $9
8010746e:	6a 09                	push   $0x9
  jmp alltraps
80107470:	e9 34 f9 ff ff       	jmp    80106da9 <alltraps>

80107475 <vector10>:
.globl vector10
vector10:
  pushl $10
80107475:	6a 0a                	push   $0xa
  jmp alltraps
80107477:	e9 2d f9 ff ff       	jmp    80106da9 <alltraps>

8010747c <vector11>:
.globl vector11
vector11:
  pushl $11
8010747c:	6a 0b                	push   $0xb
  jmp alltraps
8010747e:	e9 26 f9 ff ff       	jmp    80106da9 <alltraps>

80107483 <vector12>:
.globl vector12
vector12:
  pushl $12
80107483:	6a 0c                	push   $0xc
  jmp alltraps
80107485:	e9 1f f9 ff ff       	jmp    80106da9 <alltraps>

8010748a <vector13>:
.globl vector13
vector13:
  pushl $13
8010748a:	6a 0d                	push   $0xd
  jmp alltraps
8010748c:	e9 18 f9 ff ff       	jmp    80106da9 <alltraps>

80107491 <vector14>:
.globl vector14
vector14:
  pushl $14
80107491:	6a 0e                	push   $0xe
  jmp alltraps
80107493:	e9 11 f9 ff ff       	jmp    80106da9 <alltraps>

80107498 <vector15>:
.globl vector15
vector15:
  pushl $0
80107498:	6a 00                	push   $0x0
  pushl $15
8010749a:	6a 0f                	push   $0xf
  jmp alltraps
8010749c:	e9 08 f9 ff ff       	jmp    80106da9 <alltraps>

801074a1 <vector16>:
.globl vector16
vector16:
  pushl $0
801074a1:	6a 00                	push   $0x0
  pushl $16
801074a3:	6a 10                	push   $0x10
  jmp alltraps
801074a5:	e9 ff f8 ff ff       	jmp    80106da9 <alltraps>

801074aa <vector17>:
.globl vector17
vector17:
  pushl $17
801074aa:	6a 11                	push   $0x11
  jmp alltraps
801074ac:	e9 f8 f8 ff ff       	jmp    80106da9 <alltraps>

801074b1 <vector18>:
.globl vector18
vector18:
  pushl $0
801074b1:	6a 00                	push   $0x0
  pushl $18
801074b3:	6a 12                	push   $0x12
  jmp alltraps
801074b5:	e9 ef f8 ff ff       	jmp    80106da9 <alltraps>

801074ba <vector19>:
.globl vector19
vector19:
  pushl $0
801074ba:	6a 00                	push   $0x0
  pushl $19
801074bc:	6a 13                	push   $0x13
  jmp alltraps
801074be:	e9 e6 f8 ff ff       	jmp    80106da9 <alltraps>

801074c3 <vector20>:
.globl vector20
vector20:
  pushl $0
801074c3:	6a 00                	push   $0x0
  pushl $20
801074c5:	6a 14                	push   $0x14
  jmp alltraps
801074c7:	e9 dd f8 ff ff       	jmp    80106da9 <alltraps>

801074cc <vector21>:
.globl vector21
vector21:
  pushl $0
801074cc:	6a 00                	push   $0x0
  pushl $21
801074ce:	6a 15                	push   $0x15
  jmp alltraps
801074d0:	e9 d4 f8 ff ff       	jmp    80106da9 <alltraps>

801074d5 <vector22>:
.globl vector22
vector22:
  pushl $0
801074d5:	6a 00                	push   $0x0
  pushl $22
801074d7:	6a 16                	push   $0x16
  jmp alltraps
801074d9:	e9 cb f8 ff ff       	jmp    80106da9 <alltraps>

801074de <vector23>:
.globl vector23
vector23:
  pushl $0
801074de:	6a 00                	push   $0x0
  pushl $23
801074e0:	6a 17                	push   $0x17
  jmp alltraps
801074e2:	e9 c2 f8 ff ff       	jmp    80106da9 <alltraps>

801074e7 <vector24>:
.globl vector24
vector24:
  pushl $0
801074e7:	6a 00                	push   $0x0
  pushl $24
801074e9:	6a 18                	push   $0x18
  jmp alltraps
801074eb:	e9 b9 f8 ff ff       	jmp    80106da9 <alltraps>

801074f0 <vector25>:
.globl vector25
vector25:
  pushl $0
801074f0:	6a 00                	push   $0x0
  pushl $25
801074f2:	6a 19                	push   $0x19
  jmp alltraps
801074f4:	e9 b0 f8 ff ff       	jmp    80106da9 <alltraps>

801074f9 <vector26>:
.globl vector26
vector26:
  pushl $0
801074f9:	6a 00                	push   $0x0
  pushl $26
801074fb:	6a 1a                	push   $0x1a
  jmp alltraps
801074fd:	e9 a7 f8 ff ff       	jmp    80106da9 <alltraps>

80107502 <vector27>:
.globl vector27
vector27:
  pushl $0
80107502:	6a 00                	push   $0x0
  pushl $27
80107504:	6a 1b                	push   $0x1b
  jmp alltraps
80107506:	e9 9e f8 ff ff       	jmp    80106da9 <alltraps>

8010750b <vector28>:
.globl vector28
vector28:
  pushl $0
8010750b:	6a 00                	push   $0x0
  pushl $28
8010750d:	6a 1c                	push   $0x1c
  jmp alltraps
8010750f:	e9 95 f8 ff ff       	jmp    80106da9 <alltraps>

80107514 <vector29>:
.globl vector29
vector29:
  pushl $0
80107514:	6a 00                	push   $0x0
  pushl $29
80107516:	6a 1d                	push   $0x1d
  jmp alltraps
80107518:	e9 8c f8 ff ff       	jmp    80106da9 <alltraps>

8010751d <vector30>:
.globl vector30
vector30:
  pushl $0
8010751d:	6a 00                	push   $0x0
  pushl $30
8010751f:	6a 1e                	push   $0x1e
  jmp alltraps
80107521:	e9 83 f8 ff ff       	jmp    80106da9 <alltraps>

80107526 <vector31>:
.globl vector31
vector31:
  pushl $0
80107526:	6a 00                	push   $0x0
  pushl $31
80107528:	6a 1f                	push   $0x1f
  jmp alltraps
8010752a:	e9 7a f8 ff ff       	jmp    80106da9 <alltraps>

8010752f <vector32>:
.globl vector32
vector32:
  pushl $0
8010752f:	6a 00                	push   $0x0
  pushl $32
80107531:	6a 20                	push   $0x20
  jmp alltraps
80107533:	e9 71 f8 ff ff       	jmp    80106da9 <alltraps>

80107538 <vector33>:
.globl vector33
vector33:
  pushl $0
80107538:	6a 00                	push   $0x0
  pushl $33
8010753a:	6a 21                	push   $0x21
  jmp alltraps
8010753c:	e9 68 f8 ff ff       	jmp    80106da9 <alltraps>

80107541 <vector34>:
.globl vector34
vector34:
  pushl $0
80107541:	6a 00                	push   $0x0
  pushl $34
80107543:	6a 22                	push   $0x22
  jmp alltraps
80107545:	e9 5f f8 ff ff       	jmp    80106da9 <alltraps>

8010754a <vector35>:
.globl vector35
vector35:
  pushl $0
8010754a:	6a 00                	push   $0x0
  pushl $35
8010754c:	6a 23                	push   $0x23
  jmp alltraps
8010754e:	e9 56 f8 ff ff       	jmp    80106da9 <alltraps>

80107553 <vector36>:
.globl vector36
vector36:
  pushl $0
80107553:	6a 00                	push   $0x0
  pushl $36
80107555:	6a 24                	push   $0x24
  jmp alltraps
80107557:	e9 4d f8 ff ff       	jmp    80106da9 <alltraps>

8010755c <vector37>:
.globl vector37
vector37:
  pushl $0
8010755c:	6a 00                	push   $0x0
  pushl $37
8010755e:	6a 25                	push   $0x25
  jmp alltraps
80107560:	e9 44 f8 ff ff       	jmp    80106da9 <alltraps>

80107565 <vector38>:
.globl vector38
vector38:
  pushl $0
80107565:	6a 00                	push   $0x0
  pushl $38
80107567:	6a 26                	push   $0x26
  jmp alltraps
80107569:	e9 3b f8 ff ff       	jmp    80106da9 <alltraps>

8010756e <vector39>:
.globl vector39
vector39:
  pushl $0
8010756e:	6a 00                	push   $0x0
  pushl $39
80107570:	6a 27                	push   $0x27
  jmp alltraps
80107572:	e9 32 f8 ff ff       	jmp    80106da9 <alltraps>

80107577 <vector40>:
.globl vector40
vector40:
  pushl $0
80107577:	6a 00                	push   $0x0
  pushl $40
80107579:	6a 28                	push   $0x28
  jmp alltraps
8010757b:	e9 29 f8 ff ff       	jmp    80106da9 <alltraps>

80107580 <vector41>:
.globl vector41
vector41:
  pushl $0
80107580:	6a 00                	push   $0x0
  pushl $41
80107582:	6a 29                	push   $0x29
  jmp alltraps
80107584:	e9 20 f8 ff ff       	jmp    80106da9 <alltraps>

80107589 <vector42>:
.globl vector42
vector42:
  pushl $0
80107589:	6a 00                	push   $0x0
  pushl $42
8010758b:	6a 2a                	push   $0x2a
  jmp alltraps
8010758d:	e9 17 f8 ff ff       	jmp    80106da9 <alltraps>

80107592 <vector43>:
.globl vector43
vector43:
  pushl $0
80107592:	6a 00                	push   $0x0
  pushl $43
80107594:	6a 2b                	push   $0x2b
  jmp alltraps
80107596:	e9 0e f8 ff ff       	jmp    80106da9 <alltraps>

8010759b <vector44>:
.globl vector44
vector44:
  pushl $0
8010759b:	6a 00                	push   $0x0
  pushl $44
8010759d:	6a 2c                	push   $0x2c
  jmp alltraps
8010759f:	e9 05 f8 ff ff       	jmp    80106da9 <alltraps>

801075a4 <vector45>:
.globl vector45
vector45:
  pushl $0
801075a4:	6a 00                	push   $0x0
  pushl $45
801075a6:	6a 2d                	push   $0x2d
  jmp alltraps
801075a8:	e9 fc f7 ff ff       	jmp    80106da9 <alltraps>

801075ad <vector46>:
.globl vector46
vector46:
  pushl $0
801075ad:	6a 00                	push   $0x0
  pushl $46
801075af:	6a 2e                	push   $0x2e
  jmp alltraps
801075b1:	e9 f3 f7 ff ff       	jmp    80106da9 <alltraps>

801075b6 <vector47>:
.globl vector47
vector47:
  pushl $0
801075b6:	6a 00                	push   $0x0
  pushl $47
801075b8:	6a 2f                	push   $0x2f
  jmp alltraps
801075ba:	e9 ea f7 ff ff       	jmp    80106da9 <alltraps>

801075bf <vector48>:
.globl vector48
vector48:
  pushl $0
801075bf:	6a 00                	push   $0x0
  pushl $48
801075c1:	6a 30                	push   $0x30
  jmp alltraps
801075c3:	e9 e1 f7 ff ff       	jmp    80106da9 <alltraps>

801075c8 <vector49>:
.globl vector49
vector49:
  pushl $0
801075c8:	6a 00                	push   $0x0
  pushl $49
801075ca:	6a 31                	push   $0x31
  jmp alltraps
801075cc:	e9 d8 f7 ff ff       	jmp    80106da9 <alltraps>

801075d1 <vector50>:
.globl vector50
vector50:
  pushl $0
801075d1:	6a 00                	push   $0x0
  pushl $50
801075d3:	6a 32                	push   $0x32
  jmp alltraps
801075d5:	e9 cf f7 ff ff       	jmp    80106da9 <alltraps>

801075da <vector51>:
.globl vector51
vector51:
  pushl $0
801075da:	6a 00                	push   $0x0
  pushl $51
801075dc:	6a 33                	push   $0x33
  jmp alltraps
801075de:	e9 c6 f7 ff ff       	jmp    80106da9 <alltraps>

801075e3 <vector52>:
.globl vector52
vector52:
  pushl $0
801075e3:	6a 00                	push   $0x0
  pushl $52
801075e5:	6a 34                	push   $0x34
  jmp alltraps
801075e7:	e9 bd f7 ff ff       	jmp    80106da9 <alltraps>

801075ec <vector53>:
.globl vector53
vector53:
  pushl $0
801075ec:	6a 00                	push   $0x0
  pushl $53
801075ee:	6a 35                	push   $0x35
  jmp alltraps
801075f0:	e9 b4 f7 ff ff       	jmp    80106da9 <alltraps>

801075f5 <vector54>:
.globl vector54
vector54:
  pushl $0
801075f5:	6a 00                	push   $0x0
  pushl $54
801075f7:	6a 36                	push   $0x36
  jmp alltraps
801075f9:	e9 ab f7 ff ff       	jmp    80106da9 <alltraps>

801075fe <vector55>:
.globl vector55
vector55:
  pushl $0
801075fe:	6a 00                	push   $0x0
  pushl $55
80107600:	6a 37                	push   $0x37
  jmp alltraps
80107602:	e9 a2 f7 ff ff       	jmp    80106da9 <alltraps>

80107607 <vector56>:
.globl vector56
vector56:
  pushl $0
80107607:	6a 00                	push   $0x0
  pushl $56
80107609:	6a 38                	push   $0x38
  jmp alltraps
8010760b:	e9 99 f7 ff ff       	jmp    80106da9 <alltraps>

80107610 <vector57>:
.globl vector57
vector57:
  pushl $0
80107610:	6a 00                	push   $0x0
  pushl $57
80107612:	6a 39                	push   $0x39
  jmp alltraps
80107614:	e9 90 f7 ff ff       	jmp    80106da9 <alltraps>

80107619 <vector58>:
.globl vector58
vector58:
  pushl $0
80107619:	6a 00                	push   $0x0
  pushl $58
8010761b:	6a 3a                	push   $0x3a
  jmp alltraps
8010761d:	e9 87 f7 ff ff       	jmp    80106da9 <alltraps>

80107622 <vector59>:
.globl vector59
vector59:
  pushl $0
80107622:	6a 00                	push   $0x0
  pushl $59
80107624:	6a 3b                	push   $0x3b
  jmp alltraps
80107626:	e9 7e f7 ff ff       	jmp    80106da9 <alltraps>

8010762b <vector60>:
.globl vector60
vector60:
  pushl $0
8010762b:	6a 00                	push   $0x0
  pushl $60
8010762d:	6a 3c                	push   $0x3c
  jmp alltraps
8010762f:	e9 75 f7 ff ff       	jmp    80106da9 <alltraps>

80107634 <vector61>:
.globl vector61
vector61:
  pushl $0
80107634:	6a 00                	push   $0x0
  pushl $61
80107636:	6a 3d                	push   $0x3d
  jmp alltraps
80107638:	e9 6c f7 ff ff       	jmp    80106da9 <alltraps>

8010763d <vector62>:
.globl vector62
vector62:
  pushl $0
8010763d:	6a 00                	push   $0x0
  pushl $62
8010763f:	6a 3e                	push   $0x3e
  jmp alltraps
80107641:	e9 63 f7 ff ff       	jmp    80106da9 <alltraps>

80107646 <vector63>:
.globl vector63
vector63:
  pushl $0
80107646:	6a 00                	push   $0x0
  pushl $63
80107648:	6a 3f                	push   $0x3f
  jmp alltraps
8010764a:	e9 5a f7 ff ff       	jmp    80106da9 <alltraps>

8010764f <vector64>:
.globl vector64
vector64:
  pushl $0
8010764f:	6a 00                	push   $0x0
  pushl $64
80107651:	6a 40                	push   $0x40
  jmp alltraps
80107653:	e9 51 f7 ff ff       	jmp    80106da9 <alltraps>

80107658 <vector65>:
.globl vector65
vector65:
  pushl $0
80107658:	6a 00                	push   $0x0
  pushl $65
8010765a:	6a 41                	push   $0x41
  jmp alltraps
8010765c:	e9 48 f7 ff ff       	jmp    80106da9 <alltraps>

80107661 <vector66>:
.globl vector66
vector66:
  pushl $0
80107661:	6a 00                	push   $0x0
  pushl $66
80107663:	6a 42                	push   $0x42
  jmp alltraps
80107665:	e9 3f f7 ff ff       	jmp    80106da9 <alltraps>

8010766a <vector67>:
.globl vector67
vector67:
  pushl $0
8010766a:	6a 00                	push   $0x0
  pushl $67
8010766c:	6a 43                	push   $0x43
  jmp alltraps
8010766e:	e9 36 f7 ff ff       	jmp    80106da9 <alltraps>

80107673 <vector68>:
.globl vector68
vector68:
  pushl $0
80107673:	6a 00                	push   $0x0
  pushl $68
80107675:	6a 44                	push   $0x44
  jmp alltraps
80107677:	e9 2d f7 ff ff       	jmp    80106da9 <alltraps>

8010767c <vector69>:
.globl vector69
vector69:
  pushl $0
8010767c:	6a 00                	push   $0x0
  pushl $69
8010767e:	6a 45                	push   $0x45
  jmp alltraps
80107680:	e9 24 f7 ff ff       	jmp    80106da9 <alltraps>

80107685 <vector70>:
.globl vector70
vector70:
  pushl $0
80107685:	6a 00                	push   $0x0
  pushl $70
80107687:	6a 46                	push   $0x46
  jmp alltraps
80107689:	e9 1b f7 ff ff       	jmp    80106da9 <alltraps>

8010768e <vector71>:
.globl vector71
vector71:
  pushl $0
8010768e:	6a 00                	push   $0x0
  pushl $71
80107690:	6a 47                	push   $0x47
  jmp alltraps
80107692:	e9 12 f7 ff ff       	jmp    80106da9 <alltraps>

80107697 <vector72>:
.globl vector72
vector72:
  pushl $0
80107697:	6a 00                	push   $0x0
  pushl $72
80107699:	6a 48                	push   $0x48
  jmp alltraps
8010769b:	e9 09 f7 ff ff       	jmp    80106da9 <alltraps>

801076a0 <vector73>:
.globl vector73
vector73:
  pushl $0
801076a0:	6a 00                	push   $0x0
  pushl $73
801076a2:	6a 49                	push   $0x49
  jmp alltraps
801076a4:	e9 00 f7 ff ff       	jmp    80106da9 <alltraps>

801076a9 <vector74>:
.globl vector74
vector74:
  pushl $0
801076a9:	6a 00                	push   $0x0
  pushl $74
801076ab:	6a 4a                	push   $0x4a
  jmp alltraps
801076ad:	e9 f7 f6 ff ff       	jmp    80106da9 <alltraps>

801076b2 <vector75>:
.globl vector75
vector75:
  pushl $0
801076b2:	6a 00                	push   $0x0
  pushl $75
801076b4:	6a 4b                	push   $0x4b
  jmp alltraps
801076b6:	e9 ee f6 ff ff       	jmp    80106da9 <alltraps>

801076bb <vector76>:
.globl vector76
vector76:
  pushl $0
801076bb:	6a 00                	push   $0x0
  pushl $76
801076bd:	6a 4c                	push   $0x4c
  jmp alltraps
801076bf:	e9 e5 f6 ff ff       	jmp    80106da9 <alltraps>

801076c4 <vector77>:
.globl vector77
vector77:
  pushl $0
801076c4:	6a 00                	push   $0x0
  pushl $77
801076c6:	6a 4d                	push   $0x4d
  jmp alltraps
801076c8:	e9 dc f6 ff ff       	jmp    80106da9 <alltraps>

801076cd <vector78>:
.globl vector78
vector78:
  pushl $0
801076cd:	6a 00                	push   $0x0
  pushl $78
801076cf:	6a 4e                	push   $0x4e
  jmp alltraps
801076d1:	e9 d3 f6 ff ff       	jmp    80106da9 <alltraps>

801076d6 <vector79>:
.globl vector79
vector79:
  pushl $0
801076d6:	6a 00                	push   $0x0
  pushl $79
801076d8:	6a 4f                	push   $0x4f
  jmp alltraps
801076da:	e9 ca f6 ff ff       	jmp    80106da9 <alltraps>

801076df <vector80>:
.globl vector80
vector80:
  pushl $0
801076df:	6a 00                	push   $0x0
  pushl $80
801076e1:	6a 50                	push   $0x50
  jmp alltraps
801076e3:	e9 c1 f6 ff ff       	jmp    80106da9 <alltraps>

801076e8 <vector81>:
.globl vector81
vector81:
  pushl $0
801076e8:	6a 00                	push   $0x0
  pushl $81
801076ea:	6a 51                	push   $0x51
  jmp alltraps
801076ec:	e9 b8 f6 ff ff       	jmp    80106da9 <alltraps>

801076f1 <vector82>:
.globl vector82
vector82:
  pushl $0
801076f1:	6a 00                	push   $0x0
  pushl $82
801076f3:	6a 52                	push   $0x52
  jmp alltraps
801076f5:	e9 af f6 ff ff       	jmp    80106da9 <alltraps>

801076fa <vector83>:
.globl vector83
vector83:
  pushl $0
801076fa:	6a 00                	push   $0x0
  pushl $83
801076fc:	6a 53                	push   $0x53
  jmp alltraps
801076fe:	e9 a6 f6 ff ff       	jmp    80106da9 <alltraps>

80107703 <vector84>:
.globl vector84
vector84:
  pushl $0
80107703:	6a 00                	push   $0x0
  pushl $84
80107705:	6a 54                	push   $0x54
  jmp alltraps
80107707:	e9 9d f6 ff ff       	jmp    80106da9 <alltraps>

8010770c <vector85>:
.globl vector85
vector85:
  pushl $0
8010770c:	6a 00                	push   $0x0
  pushl $85
8010770e:	6a 55                	push   $0x55
  jmp alltraps
80107710:	e9 94 f6 ff ff       	jmp    80106da9 <alltraps>

80107715 <vector86>:
.globl vector86
vector86:
  pushl $0
80107715:	6a 00                	push   $0x0
  pushl $86
80107717:	6a 56                	push   $0x56
  jmp alltraps
80107719:	e9 8b f6 ff ff       	jmp    80106da9 <alltraps>

8010771e <vector87>:
.globl vector87
vector87:
  pushl $0
8010771e:	6a 00                	push   $0x0
  pushl $87
80107720:	6a 57                	push   $0x57
  jmp alltraps
80107722:	e9 82 f6 ff ff       	jmp    80106da9 <alltraps>

80107727 <vector88>:
.globl vector88
vector88:
  pushl $0
80107727:	6a 00                	push   $0x0
  pushl $88
80107729:	6a 58                	push   $0x58
  jmp alltraps
8010772b:	e9 79 f6 ff ff       	jmp    80106da9 <alltraps>

80107730 <vector89>:
.globl vector89
vector89:
  pushl $0
80107730:	6a 00                	push   $0x0
  pushl $89
80107732:	6a 59                	push   $0x59
  jmp alltraps
80107734:	e9 70 f6 ff ff       	jmp    80106da9 <alltraps>

80107739 <vector90>:
.globl vector90
vector90:
  pushl $0
80107739:	6a 00                	push   $0x0
  pushl $90
8010773b:	6a 5a                	push   $0x5a
  jmp alltraps
8010773d:	e9 67 f6 ff ff       	jmp    80106da9 <alltraps>

80107742 <vector91>:
.globl vector91
vector91:
  pushl $0
80107742:	6a 00                	push   $0x0
  pushl $91
80107744:	6a 5b                	push   $0x5b
  jmp alltraps
80107746:	e9 5e f6 ff ff       	jmp    80106da9 <alltraps>

8010774b <vector92>:
.globl vector92
vector92:
  pushl $0
8010774b:	6a 00                	push   $0x0
  pushl $92
8010774d:	6a 5c                	push   $0x5c
  jmp alltraps
8010774f:	e9 55 f6 ff ff       	jmp    80106da9 <alltraps>

80107754 <vector93>:
.globl vector93
vector93:
  pushl $0
80107754:	6a 00                	push   $0x0
  pushl $93
80107756:	6a 5d                	push   $0x5d
  jmp alltraps
80107758:	e9 4c f6 ff ff       	jmp    80106da9 <alltraps>

8010775d <vector94>:
.globl vector94
vector94:
  pushl $0
8010775d:	6a 00                	push   $0x0
  pushl $94
8010775f:	6a 5e                	push   $0x5e
  jmp alltraps
80107761:	e9 43 f6 ff ff       	jmp    80106da9 <alltraps>

80107766 <vector95>:
.globl vector95
vector95:
  pushl $0
80107766:	6a 00                	push   $0x0
  pushl $95
80107768:	6a 5f                	push   $0x5f
  jmp alltraps
8010776a:	e9 3a f6 ff ff       	jmp    80106da9 <alltraps>

8010776f <vector96>:
.globl vector96
vector96:
  pushl $0
8010776f:	6a 00                	push   $0x0
  pushl $96
80107771:	6a 60                	push   $0x60
  jmp alltraps
80107773:	e9 31 f6 ff ff       	jmp    80106da9 <alltraps>

80107778 <vector97>:
.globl vector97
vector97:
  pushl $0
80107778:	6a 00                	push   $0x0
  pushl $97
8010777a:	6a 61                	push   $0x61
  jmp alltraps
8010777c:	e9 28 f6 ff ff       	jmp    80106da9 <alltraps>

80107781 <vector98>:
.globl vector98
vector98:
  pushl $0
80107781:	6a 00                	push   $0x0
  pushl $98
80107783:	6a 62                	push   $0x62
  jmp alltraps
80107785:	e9 1f f6 ff ff       	jmp    80106da9 <alltraps>

8010778a <vector99>:
.globl vector99
vector99:
  pushl $0
8010778a:	6a 00                	push   $0x0
  pushl $99
8010778c:	6a 63                	push   $0x63
  jmp alltraps
8010778e:	e9 16 f6 ff ff       	jmp    80106da9 <alltraps>

80107793 <vector100>:
.globl vector100
vector100:
  pushl $0
80107793:	6a 00                	push   $0x0
  pushl $100
80107795:	6a 64                	push   $0x64
  jmp alltraps
80107797:	e9 0d f6 ff ff       	jmp    80106da9 <alltraps>

8010779c <vector101>:
.globl vector101
vector101:
  pushl $0
8010779c:	6a 00                	push   $0x0
  pushl $101
8010779e:	6a 65                	push   $0x65
  jmp alltraps
801077a0:	e9 04 f6 ff ff       	jmp    80106da9 <alltraps>

801077a5 <vector102>:
.globl vector102
vector102:
  pushl $0
801077a5:	6a 00                	push   $0x0
  pushl $102
801077a7:	6a 66                	push   $0x66
  jmp alltraps
801077a9:	e9 fb f5 ff ff       	jmp    80106da9 <alltraps>

801077ae <vector103>:
.globl vector103
vector103:
  pushl $0
801077ae:	6a 00                	push   $0x0
  pushl $103
801077b0:	6a 67                	push   $0x67
  jmp alltraps
801077b2:	e9 f2 f5 ff ff       	jmp    80106da9 <alltraps>

801077b7 <vector104>:
.globl vector104
vector104:
  pushl $0
801077b7:	6a 00                	push   $0x0
  pushl $104
801077b9:	6a 68                	push   $0x68
  jmp alltraps
801077bb:	e9 e9 f5 ff ff       	jmp    80106da9 <alltraps>

801077c0 <vector105>:
.globl vector105
vector105:
  pushl $0
801077c0:	6a 00                	push   $0x0
  pushl $105
801077c2:	6a 69                	push   $0x69
  jmp alltraps
801077c4:	e9 e0 f5 ff ff       	jmp    80106da9 <alltraps>

801077c9 <vector106>:
.globl vector106
vector106:
  pushl $0
801077c9:	6a 00                	push   $0x0
  pushl $106
801077cb:	6a 6a                	push   $0x6a
  jmp alltraps
801077cd:	e9 d7 f5 ff ff       	jmp    80106da9 <alltraps>

801077d2 <vector107>:
.globl vector107
vector107:
  pushl $0
801077d2:	6a 00                	push   $0x0
  pushl $107
801077d4:	6a 6b                	push   $0x6b
  jmp alltraps
801077d6:	e9 ce f5 ff ff       	jmp    80106da9 <alltraps>

801077db <vector108>:
.globl vector108
vector108:
  pushl $0
801077db:	6a 00                	push   $0x0
  pushl $108
801077dd:	6a 6c                	push   $0x6c
  jmp alltraps
801077df:	e9 c5 f5 ff ff       	jmp    80106da9 <alltraps>

801077e4 <vector109>:
.globl vector109
vector109:
  pushl $0
801077e4:	6a 00                	push   $0x0
  pushl $109
801077e6:	6a 6d                	push   $0x6d
  jmp alltraps
801077e8:	e9 bc f5 ff ff       	jmp    80106da9 <alltraps>

801077ed <vector110>:
.globl vector110
vector110:
  pushl $0
801077ed:	6a 00                	push   $0x0
  pushl $110
801077ef:	6a 6e                	push   $0x6e
  jmp alltraps
801077f1:	e9 b3 f5 ff ff       	jmp    80106da9 <alltraps>

801077f6 <vector111>:
.globl vector111
vector111:
  pushl $0
801077f6:	6a 00                	push   $0x0
  pushl $111
801077f8:	6a 6f                	push   $0x6f
  jmp alltraps
801077fa:	e9 aa f5 ff ff       	jmp    80106da9 <alltraps>

801077ff <vector112>:
.globl vector112
vector112:
  pushl $0
801077ff:	6a 00                	push   $0x0
  pushl $112
80107801:	6a 70                	push   $0x70
  jmp alltraps
80107803:	e9 a1 f5 ff ff       	jmp    80106da9 <alltraps>

80107808 <vector113>:
.globl vector113
vector113:
  pushl $0
80107808:	6a 00                	push   $0x0
  pushl $113
8010780a:	6a 71                	push   $0x71
  jmp alltraps
8010780c:	e9 98 f5 ff ff       	jmp    80106da9 <alltraps>

80107811 <vector114>:
.globl vector114
vector114:
  pushl $0
80107811:	6a 00                	push   $0x0
  pushl $114
80107813:	6a 72                	push   $0x72
  jmp alltraps
80107815:	e9 8f f5 ff ff       	jmp    80106da9 <alltraps>

8010781a <vector115>:
.globl vector115
vector115:
  pushl $0
8010781a:	6a 00                	push   $0x0
  pushl $115
8010781c:	6a 73                	push   $0x73
  jmp alltraps
8010781e:	e9 86 f5 ff ff       	jmp    80106da9 <alltraps>

80107823 <vector116>:
.globl vector116
vector116:
  pushl $0
80107823:	6a 00                	push   $0x0
  pushl $116
80107825:	6a 74                	push   $0x74
  jmp alltraps
80107827:	e9 7d f5 ff ff       	jmp    80106da9 <alltraps>

8010782c <vector117>:
.globl vector117
vector117:
  pushl $0
8010782c:	6a 00                	push   $0x0
  pushl $117
8010782e:	6a 75                	push   $0x75
  jmp alltraps
80107830:	e9 74 f5 ff ff       	jmp    80106da9 <alltraps>

80107835 <vector118>:
.globl vector118
vector118:
  pushl $0
80107835:	6a 00                	push   $0x0
  pushl $118
80107837:	6a 76                	push   $0x76
  jmp alltraps
80107839:	e9 6b f5 ff ff       	jmp    80106da9 <alltraps>

8010783e <vector119>:
.globl vector119
vector119:
  pushl $0
8010783e:	6a 00                	push   $0x0
  pushl $119
80107840:	6a 77                	push   $0x77
  jmp alltraps
80107842:	e9 62 f5 ff ff       	jmp    80106da9 <alltraps>

80107847 <vector120>:
.globl vector120
vector120:
  pushl $0
80107847:	6a 00                	push   $0x0
  pushl $120
80107849:	6a 78                	push   $0x78
  jmp alltraps
8010784b:	e9 59 f5 ff ff       	jmp    80106da9 <alltraps>

80107850 <vector121>:
.globl vector121
vector121:
  pushl $0
80107850:	6a 00                	push   $0x0
  pushl $121
80107852:	6a 79                	push   $0x79
  jmp alltraps
80107854:	e9 50 f5 ff ff       	jmp    80106da9 <alltraps>

80107859 <vector122>:
.globl vector122
vector122:
  pushl $0
80107859:	6a 00                	push   $0x0
  pushl $122
8010785b:	6a 7a                	push   $0x7a
  jmp alltraps
8010785d:	e9 47 f5 ff ff       	jmp    80106da9 <alltraps>

80107862 <vector123>:
.globl vector123
vector123:
  pushl $0
80107862:	6a 00                	push   $0x0
  pushl $123
80107864:	6a 7b                	push   $0x7b
  jmp alltraps
80107866:	e9 3e f5 ff ff       	jmp    80106da9 <alltraps>

8010786b <vector124>:
.globl vector124
vector124:
  pushl $0
8010786b:	6a 00                	push   $0x0
  pushl $124
8010786d:	6a 7c                	push   $0x7c
  jmp alltraps
8010786f:	e9 35 f5 ff ff       	jmp    80106da9 <alltraps>

80107874 <vector125>:
.globl vector125
vector125:
  pushl $0
80107874:	6a 00                	push   $0x0
  pushl $125
80107876:	6a 7d                	push   $0x7d
  jmp alltraps
80107878:	e9 2c f5 ff ff       	jmp    80106da9 <alltraps>

8010787d <vector126>:
.globl vector126
vector126:
  pushl $0
8010787d:	6a 00                	push   $0x0
  pushl $126
8010787f:	6a 7e                	push   $0x7e
  jmp alltraps
80107881:	e9 23 f5 ff ff       	jmp    80106da9 <alltraps>

80107886 <vector127>:
.globl vector127
vector127:
  pushl $0
80107886:	6a 00                	push   $0x0
  pushl $127
80107888:	6a 7f                	push   $0x7f
  jmp alltraps
8010788a:	e9 1a f5 ff ff       	jmp    80106da9 <alltraps>

8010788f <vector128>:
.globl vector128
vector128:
  pushl $0
8010788f:	6a 00                	push   $0x0
  pushl $128
80107891:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107896:	e9 0e f5 ff ff       	jmp    80106da9 <alltraps>

8010789b <vector129>:
.globl vector129
vector129:
  pushl $0
8010789b:	6a 00                	push   $0x0
  pushl $129
8010789d:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801078a2:	e9 02 f5 ff ff       	jmp    80106da9 <alltraps>

801078a7 <vector130>:
.globl vector130
vector130:
  pushl $0
801078a7:	6a 00                	push   $0x0
  pushl $130
801078a9:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801078ae:	e9 f6 f4 ff ff       	jmp    80106da9 <alltraps>

801078b3 <vector131>:
.globl vector131
vector131:
  pushl $0
801078b3:	6a 00                	push   $0x0
  pushl $131
801078b5:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801078ba:	e9 ea f4 ff ff       	jmp    80106da9 <alltraps>

801078bf <vector132>:
.globl vector132
vector132:
  pushl $0
801078bf:	6a 00                	push   $0x0
  pushl $132
801078c1:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801078c6:	e9 de f4 ff ff       	jmp    80106da9 <alltraps>

801078cb <vector133>:
.globl vector133
vector133:
  pushl $0
801078cb:	6a 00                	push   $0x0
  pushl $133
801078cd:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801078d2:	e9 d2 f4 ff ff       	jmp    80106da9 <alltraps>

801078d7 <vector134>:
.globl vector134
vector134:
  pushl $0
801078d7:	6a 00                	push   $0x0
  pushl $134
801078d9:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801078de:	e9 c6 f4 ff ff       	jmp    80106da9 <alltraps>

801078e3 <vector135>:
.globl vector135
vector135:
  pushl $0
801078e3:	6a 00                	push   $0x0
  pushl $135
801078e5:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801078ea:	e9 ba f4 ff ff       	jmp    80106da9 <alltraps>

801078ef <vector136>:
.globl vector136
vector136:
  pushl $0
801078ef:	6a 00                	push   $0x0
  pushl $136
801078f1:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801078f6:	e9 ae f4 ff ff       	jmp    80106da9 <alltraps>

801078fb <vector137>:
.globl vector137
vector137:
  pushl $0
801078fb:	6a 00                	push   $0x0
  pushl $137
801078fd:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107902:	e9 a2 f4 ff ff       	jmp    80106da9 <alltraps>

80107907 <vector138>:
.globl vector138
vector138:
  pushl $0
80107907:	6a 00                	push   $0x0
  pushl $138
80107909:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010790e:	e9 96 f4 ff ff       	jmp    80106da9 <alltraps>

80107913 <vector139>:
.globl vector139
vector139:
  pushl $0
80107913:	6a 00                	push   $0x0
  pushl $139
80107915:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010791a:	e9 8a f4 ff ff       	jmp    80106da9 <alltraps>

8010791f <vector140>:
.globl vector140
vector140:
  pushl $0
8010791f:	6a 00                	push   $0x0
  pushl $140
80107921:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107926:	e9 7e f4 ff ff       	jmp    80106da9 <alltraps>

8010792b <vector141>:
.globl vector141
vector141:
  pushl $0
8010792b:	6a 00                	push   $0x0
  pushl $141
8010792d:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107932:	e9 72 f4 ff ff       	jmp    80106da9 <alltraps>

80107937 <vector142>:
.globl vector142
vector142:
  pushl $0
80107937:	6a 00                	push   $0x0
  pushl $142
80107939:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010793e:	e9 66 f4 ff ff       	jmp    80106da9 <alltraps>

80107943 <vector143>:
.globl vector143
vector143:
  pushl $0
80107943:	6a 00                	push   $0x0
  pushl $143
80107945:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010794a:	e9 5a f4 ff ff       	jmp    80106da9 <alltraps>

8010794f <vector144>:
.globl vector144
vector144:
  pushl $0
8010794f:	6a 00                	push   $0x0
  pushl $144
80107951:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107956:	e9 4e f4 ff ff       	jmp    80106da9 <alltraps>

8010795b <vector145>:
.globl vector145
vector145:
  pushl $0
8010795b:	6a 00                	push   $0x0
  pushl $145
8010795d:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107962:	e9 42 f4 ff ff       	jmp    80106da9 <alltraps>

80107967 <vector146>:
.globl vector146
vector146:
  pushl $0
80107967:	6a 00                	push   $0x0
  pushl $146
80107969:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010796e:	e9 36 f4 ff ff       	jmp    80106da9 <alltraps>

80107973 <vector147>:
.globl vector147
vector147:
  pushl $0
80107973:	6a 00                	push   $0x0
  pushl $147
80107975:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010797a:	e9 2a f4 ff ff       	jmp    80106da9 <alltraps>

8010797f <vector148>:
.globl vector148
vector148:
  pushl $0
8010797f:	6a 00                	push   $0x0
  pushl $148
80107981:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107986:	e9 1e f4 ff ff       	jmp    80106da9 <alltraps>

8010798b <vector149>:
.globl vector149
vector149:
  pushl $0
8010798b:	6a 00                	push   $0x0
  pushl $149
8010798d:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107992:	e9 12 f4 ff ff       	jmp    80106da9 <alltraps>

80107997 <vector150>:
.globl vector150
vector150:
  pushl $0
80107997:	6a 00                	push   $0x0
  pushl $150
80107999:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010799e:	e9 06 f4 ff ff       	jmp    80106da9 <alltraps>

801079a3 <vector151>:
.globl vector151
vector151:
  pushl $0
801079a3:	6a 00                	push   $0x0
  pushl $151
801079a5:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801079aa:	e9 fa f3 ff ff       	jmp    80106da9 <alltraps>

801079af <vector152>:
.globl vector152
vector152:
  pushl $0
801079af:	6a 00                	push   $0x0
  pushl $152
801079b1:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801079b6:	e9 ee f3 ff ff       	jmp    80106da9 <alltraps>

801079bb <vector153>:
.globl vector153
vector153:
  pushl $0
801079bb:	6a 00                	push   $0x0
  pushl $153
801079bd:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801079c2:	e9 e2 f3 ff ff       	jmp    80106da9 <alltraps>

801079c7 <vector154>:
.globl vector154
vector154:
  pushl $0
801079c7:	6a 00                	push   $0x0
  pushl $154
801079c9:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801079ce:	e9 d6 f3 ff ff       	jmp    80106da9 <alltraps>

801079d3 <vector155>:
.globl vector155
vector155:
  pushl $0
801079d3:	6a 00                	push   $0x0
  pushl $155
801079d5:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801079da:	e9 ca f3 ff ff       	jmp    80106da9 <alltraps>

801079df <vector156>:
.globl vector156
vector156:
  pushl $0
801079df:	6a 00                	push   $0x0
  pushl $156
801079e1:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801079e6:	e9 be f3 ff ff       	jmp    80106da9 <alltraps>

801079eb <vector157>:
.globl vector157
vector157:
  pushl $0
801079eb:	6a 00                	push   $0x0
  pushl $157
801079ed:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801079f2:	e9 b2 f3 ff ff       	jmp    80106da9 <alltraps>

801079f7 <vector158>:
.globl vector158
vector158:
  pushl $0
801079f7:	6a 00                	push   $0x0
  pushl $158
801079f9:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801079fe:	e9 a6 f3 ff ff       	jmp    80106da9 <alltraps>

80107a03 <vector159>:
.globl vector159
vector159:
  pushl $0
80107a03:	6a 00                	push   $0x0
  pushl $159
80107a05:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107a0a:	e9 9a f3 ff ff       	jmp    80106da9 <alltraps>

80107a0f <vector160>:
.globl vector160
vector160:
  pushl $0
80107a0f:	6a 00                	push   $0x0
  pushl $160
80107a11:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107a16:	e9 8e f3 ff ff       	jmp    80106da9 <alltraps>

80107a1b <vector161>:
.globl vector161
vector161:
  pushl $0
80107a1b:	6a 00                	push   $0x0
  pushl $161
80107a1d:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107a22:	e9 82 f3 ff ff       	jmp    80106da9 <alltraps>

80107a27 <vector162>:
.globl vector162
vector162:
  pushl $0
80107a27:	6a 00                	push   $0x0
  pushl $162
80107a29:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107a2e:	e9 76 f3 ff ff       	jmp    80106da9 <alltraps>

80107a33 <vector163>:
.globl vector163
vector163:
  pushl $0
80107a33:	6a 00                	push   $0x0
  pushl $163
80107a35:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107a3a:	e9 6a f3 ff ff       	jmp    80106da9 <alltraps>

80107a3f <vector164>:
.globl vector164
vector164:
  pushl $0
80107a3f:	6a 00                	push   $0x0
  pushl $164
80107a41:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107a46:	e9 5e f3 ff ff       	jmp    80106da9 <alltraps>

80107a4b <vector165>:
.globl vector165
vector165:
  pushl $0
80107a4b:	6a 00                	push   $0x0
  pushl $165
80107a4d:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107a52:	e9 52 f3 ff ff       	jmp    80106da9 <alltraps>

80107a57 <vector166>:
.globl vector166
vector166:
  pushl $0
80107a57:	6a 00                	push   $0x0
  pushl $166
80107a59:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107a5e:	e9 46 f3 ff ff       	jmp    80106da9 <alltraps>

80107a63 <vector167>:
.globl vector167
vector167:
  pushl $0
80107a63:	6a 00                	push   $0x0
  pushl $167
80107a65:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107a6a:	e9 3a f3 ff ff       	jmp    80106da9 <alltraps>

80107a6f <vector168>:
.globl vector168
vector168:
  pushl $0
80107a6f:	6a 00                	push   $0x0
  pushl $168
80107a71:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107a76:	e9 2e f3 ff ff       	jmp    80106da9 <alltraps>

80107a7b <vector169>:
.globl vector169
vector169:
  pushl $0
80107a7b:	6a 00                	push   $0x0
  pushl $169
80107a7d:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107a82:	e9 22 f3 ff ff       	jmp    80106da9 <alltraps>

80107a87 <vector170>:
.globl vector170
vector170:
  pushl $0
80107a87:	6a 00                	push   $0x0
  pushl $170
80107a89:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107a8e:	e9 16 f3 ff ff       	jmp    80106da9 <alltraps>

80107a93 <vector171>:
.globl vector171
vector171:
  pushl $0
80107a93:	6a 00                	push   $0x0
  pushl $171
80107a95:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107a9a:	e9 0a f3 ff ff       	jmp    80106da9 <alltraps>

80107a9f <vector172>:
.globl vector172
vector172:
  pushl $0
80107a9f:	6a 00                	push   $0x0
  pushl $172
80107aa1:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107aa6:	e9 fe f2 ff ff       	jmp    80106da9 <alltraps>

80107aab <vector173>:
.globl vector173
vector173:
  pushl $0
80107aab:	6a 00                	push   $0x0
  pushl $173
80107aad:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107ab2:	e9 f2 f2 ff ff       	jmp    80106da9 <alltraps>

80107ab7 <vector174>:
.globl vector174
vector174:
  pushl $0
80107ab7:	6a 00                	push   $0x0
  pushl $174
80107ab9:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107abe:	e9 e6 f2 ff ff       	jmp    80106da9 <alltraps>

80107ac3 <vector175>:
.globl vector175
vector175:
  pushl $0
80107ac3:	6a 00                	push   $0x0
  pushl $175
80107ac5:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107aca:	e9 da f2 ff ff       	jmp    80106da9 <alltraps>

80107acf <vector176>:
.globl vector176
vector176:
  pushl $0
80107acf:	6a 00                	push   $0x0
  pushl $176
80107ad1:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107ad6:	e9 ce f2 ff ff       	jmp    80106da9 <alltraps>

80107adb <vector177>:
.globl vector177
vector177:
  pushl $0
80107adb:	6a 00                	push   $0x0
  pushl $177
80107add:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107ae2:	e9 c2 f2 ff ff       	jmp    80106da9 <alltraps>

80107ae7 <vector178>:
.globl vector178
vector178:
  pushl $0
80107ae7:	6a 00                	push   $0x0
  pushl $178
80107ae9:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107aee:	e9 b6 f2 ff ff       	jmp    80106da9 <alltraps>

80107af3 <vector179>:
.globl vector179
vector179:
  pushl $0
80107af3:	6a 00                	push   $0x0
  pushl $179
80107af5:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107afa:	e9 aa f2 ff ff       	jmp    80106da9 <alltraps>

80107aff <vector180>:
.globl vector180
vector180:
  pushl $0
80107aff:	6a 00                	push   $0x0
  pushl $180
80107b01:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107b06:	e9 9e f2 ff ff       	jmp    80106da9 <alltraps>

80107b0b <vector181>:
.globl vector181
vector181:
  pushl $0
80107b0b:	6a 00                	push   $0x0
  pushl $181
80107b0d:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107b12:	e9 92 f2 ff ff       	jmp    80106da9 <alltraps>

80107b17 <vector182>:
.globl vector182
vector182:
  pushl $0
80107b17:	6a 00                	push   $0x0
  pushl $182
80107b19:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107b1e:	e9 86 f2 ff ff       	jmp    80106da9 <alltraps>

80107b23 <vector183>:
.globl vector183
vector183:
  pushl $0
80107b23:	6a 00                	push   $0x0
  pushl $183
80107b25:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107b2a:	e9 7a f2 ff ff       	jmp    80106da9 <alltraps>

80107b2f <vector184>:
.globl vector184
vector184:
  pushl $0
80107b2f:	6a 00                	push   $0x0
  pushl $184
80107b31:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107b36:	e9 6e f2 ff ff       	jmp    80106da9 <alltraps>

80107b3b <vector185>:
.globl vector185
vector185:
  pushl $0
80107b3b:	6a 00                	push   $0x0
  pushl $185
80107b3d:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107b42:	e9 62 f2 ff ff       	jmp    80106da9 <alltraps>

80107b47 <vector186>:
.globl vector186
vector186:
  pushl $0
80107b47:	6a 00                	push   $0x0
  pushl $186
80107b49:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107b4e:	e9 56 f2 ff ff       	jmp    80106da9 <alltraps>

80107b53 <vector187>:
.globl vector187
vector187:
  pushl $0
80107b53:	6a 00                	push   $0x0
  pushl $187
80107b55:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107b5a:	e9 4a f2 ff ff       	jmp    80106da9 <alltraps>

80107b5f <vector188>:
.globl vector188
vector188:
  pushl $0
80107b5f:	6a 00                	push   $0x0
  pushl $188
80107b61:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107b66:	e9 3e f2 ff ff       	jmp    80106da9 <alltraps>

80107b6b <vector189>:
.globl vector189
vector189:
  pushl $0
80107b6b:	6a 00                	push   $0x0
  pushl $189
80107b6d:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107b72:	e9 32 f2 ff ff       	jmp    80106da9 <alltraps>

80107b77 <vector190>:
.globl vector190
vector190:
  pushl $0
80107b77:	6a 00                	push   $0x0
  pushl $190
80107b79:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107b7e:	e9 26 f2 ff ff       	jmp    80106da9 <alltraps>

80107b83 <vector191>:
.globl vector191
vector191:
  pushl $0
80107b83:	6a 00                	push   $0x0
  pushl $191
80107b85:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107b8a:	e9 1a f2 ff ff       	jmp    80106da9 <alltraps>

80107b8f <vector192>:
.globl vector192
vector192:
  pushl $0
80107b8f:	6a 00                	push   $0x0
  pushl $192
80107b91:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107b96:	e9 0e f2 ff ff       	jmp    80106da9 <alltraps>

80107b9b <vector193>:
.globl vector193
vector193:
  pushl $0
80107b9b:	6a 00                	push   $0x0
  pushl $193
80107b9d:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107ba2:	e9 02 f2 ff ff       	jmp    80106da9 <alltraps>

80107ba7 <vector194>:
.globl vector194
vector194:
  pushl $0
80107ba7:	6a 00                	push   $0x0
  pushl $194
80107ba9:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107bae:	e9 f6 f1 ff ff       	jmp    80106da9 <alltraps>

80107bb3 <vector195>:
.globl vector195
vector195:
  pushl $0
80107bb3:	6a 00                	push   $0x0
  pushl $195
80107bb5:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107bba:	e9 ea f1 ff ff       	jmp    80106da9 <alltraps>

80107bbf <vector196>:
.globl vector196
vector196:
  pushl $0
80107bbf:	6a 00                	push   $0x0
  pushl $196
80107bc1:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107bc6:	e9 de f1 ff ff       	jmp    80106da9 <alltraps>

80107bcb <vector197>:
.globl vector197
vector197:
  pushl $0
80107bcb:	6a 00                	push   $0x0
  pushl $197
80107bcd:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107bd2:	e9 d2 f1 ff ff       	jmp    80106da9 <alltraps>

80107bd7 <vector198>:
.globl vector198
vector198:
  pushl $0
80107bd7:	6a 00                	push   $0x0
  pushl $198
80107bd9:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107bde:	e9 c6 f1 ff ff       	jmp    80106da9 <alltraps>

80107be3 <vector199>:
.globl vector199
vector199:
  pushl $0
80107be3:	6a 00                	push   $0x0
  pushl $199
80107be5:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107bea:	e9 ba f1 ff ff       	jmp    80106da9 <alltraps>

80107bef <vector200>:
.globl vector200
vector200:
  pushl $0
80107bef:	6a 00                	push   $0x0
  pushl $200
80107bf1:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107bf6:	e9 ae f1 ff ff       	jmp    80106da9 <alltraps>

80107bfb <vector201>:
.globl vector201
vector201:
  pushl $0
80107bfb:	6a 00                	push   $0x0
  pushl $201
80107bfd:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107c02:	e9 a2 f1 ff ff       	jmp    80106da9 <alltraps>

80107c07 <vector202>:
.globl vector202
vector202:
  pushl $0
80107c07:	6a 00                	push   $0x0
  pushl $202
80107c09:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107c0e:	e9 96 f1 ff ff       	jmp    80106da9 <alltraps>

80107c13 <vector203>:
.globl vector203
vector203:
  pushl $0
80107c13:	6a 00                	push   $0x0
  pushl $203
80107c15:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107c1a:	e9 8a f1 ff ff       	jmp    80106da9 <alltraps>

80107c1f <vector204>:
.globl vector204
vector204:
  pushl $0
80107c1f:	6a 00                	push   $0x0
  pushl $204
80107c21:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107c26:	e9 7e f1 ff ff       	jmp    80106da9 <alltraps>

80107c2b <vector205>:
.globl vector205
vector205:
  pushl $0
80107c2b:	6a 00                	push   $0x0
  pushl $205
80107c2d:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107c32:	e9 72 f1 ff ff       	jmp    80106da9 <alltraps>

80107c37 <vector206>:
.globl vector206
vector206:
  pushl $0
80107c37:	6a 00                	push   $0x0
  pushl $206
80107c39:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107c3e:	e9 66 f1 ff ff       	jmp    80106da9 <alltraps>

80107c43 <vector207>:
.globl vector207
vector207:
  pushl $0
80107c43:	6a 00                	push   $0x0
  pushl $207
80107c45:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107c4a:	e9 5a f1 ff ff       	jmp    80106da9 <alltraps>

80107c4f <vector208>:
.globl vector208
vector208:
  pushl $0
80107c4f:	6a 00                	push   $0x0
  pushl $208
80107c51:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107c56:	e9 4e f1 ff ff       	jmp    80106da9 <alltraps>

80107c5b <vector209>:
.globl vector209
vector209:
  pushl $0
80107c5b:	6a 00                	push   $0x0
  pushl $209
80107c5d:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107c62:	e9 42 f1 ff ff       	jmp    80106da9 <alltraps>

80107c67 <vector210>:
.globl vector210
vector210:
  pushl $0
80107c67:	6a 00                	push   $0x0
  pushl $210
80107c69:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107c6e:	e9 36 f1 ff ff       	jmp    80106da9 <alltraps>

80107c73 <vector211>:
.globl vector211
vector211:
  pushl $0
80107c73:	6a 00                	push   $0x0
  pushl $211
80107c75:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107c7a:	e9 2a f1 ff ff       	jmp    80106da9 <alltraps>

80107c7f <vector212>:
.globl vector212
vector212:
  pushl $0
80107c7f:	6a 00                	push   $0x0
  pushl $212
80107c81:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107c86:	e9 1e f1 ff ff       	jmp    80106da9 <alltraps>

80107c8b <vector213>:
.globl vector213
vector213:
  pushl $0
80107c8b:	6a 00                	push   $0x0
  pushl $213
80107c8d:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107c92:	e9 12 f1 ff ff       	jmp    80106da9 <alltraps>

80107c97 <vector214>:
.globl vector214
vector214:
  pushl $0
80107c97:	6a 00                	push   $0x0
  pushl $214
80107c99:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107c9e:	e9 06 f1 ff ff       	jmp    80106da9 <alltraps>

80107ca3 <vector215>:
.globl vector215
vector215:
  pushl $0
80107ca3:	6a 00                	push   $0x0
  pushl $215
80107ca5:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107caa:	e9 fa f0 ff ff       	jmp    80106da9 <alltraps>

80107caf <vector216>:
.globl vector216
vector216:
  pushl $0
80107caf:	6a 00                	push   $0x0
  pushl $216
80107cb1:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107cb6:	e9 ee f0 ff ff       	jmp    80106da9 <alltraps>

80107cbb <vector217>:
.globl vector217
vector217:
  pushl $0
80107cbb:	6a 00                	push   $0x0
  pushl $217
80107cbd:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107cc2:	e9 e2 f0 ff ff       	jmp    80106da9 <alltraps>

80107cc7 <vector218>:
.globl vector218
vector218:
  pushl $0
80107cc7:	6a 00                	push   $0x0
  pushl $218
80107cc9:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107cce:	e9 d6 f0 ff ff       	jmp    80106da9 <alltraps>

80107cd3 <vector219>:
.globl vector219
vector219:
  pushl $0
80107cd3:	6a 00                	push   $0x0
  pushl $219
80107cd5:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107cda:	e9 ca f0 ff ff       	jmp    80106da9 <alltraps>

80107cdf <vector220>:
.globl vector220
vector220:
  pushl $0
80107cdf:	6a 00                	push   $0x0
  pushl $220
80107ce1:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107ce6:	e9 be f0 ff ff       	jmp    80106da9 <alltraps>

80107ceb <vector221>:
.globl vector221
vector221:
  pushl $0
80107ceb:	6a 00                	push   $0x0
  pushl $221
80107ced:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107cf2:	e9 b2 f0 ff ff       	jmp    80106da9 <alltraps>

80107cf7 <vector222>:
.globl vector222
vector222:
  pushl $0
80107cf7:	6a 00                	push   $0x0
  pushl $222
80107cf9:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107cfe:	e9 a6 f0 ff ff       	jmp    80106da9 <alltraps>

80107d03 <vector223>:
.globl vector223
vector223:
  pushl $0
80107d03:	6a 00                	push   $0x0
  pushl $223
80107d05:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107d0a:	e9 9a f0 ff ff       	jmp    80106da9 <alltraps>

80107d0f <vector224>:
.globl vector224
vector224:
  pushl $0
80107d0f:	6a 00                	push   $0x0
  pushl $224
80107d11:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107d16:	e9 8e f0 ff ff       	jmp    80106da9 <alltraps>

80107d1b <vector225>:
.globl vector225
vector225:
  pushl $0
80107d1b:	6a 00                	push   $0x0
  pushl $225
80107d1d:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107d22:	e9 82 f0 ff ff       	jmp    80106da9 <alltraps>

80107d27 <vector226>:
.globl vector226
vector226:
  pushl $0
80107d27:	6a 00                	push   $0x0
  pushl $226
80107d29:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107d2e:	e9 76 f0 ff ff       	jmp    80106da9 <alltraps>

80107d33 <vector227>:
.globl vector227
vector227:
  pushl $0
80107d33:	6a 00                	push   $0x0
  pushl $227
80107d35:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107d3a:	e9 6a f0 ff ff       	jmp    80106da9 <alltraps>

80107d3f <vector228>:
.globl vector228
vector228:
  pushl $0
80107d3f:	6a 00                	push   $0x0
  pushl $228
80107d41:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107d46:	e9 5e f0 ff ff       	jmp    80106da9 <alltraps>

80107d4b <vector229>:
.globl vector229
vector229:
  pushl $0
80107d4b:	6a 00                	push   $0x0
  pushl $229
80107d4d:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107d52:	e9 52 f0 ff ff       	jmp    80106da9 <alltraps>

80107d57 <vector230>:
.globl vector230
vector230:
  pushl $0
80107d57:	6a 00                	push   $0x0
  pushl $230
80107d59:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107d5e:	e9 46 f0 ff ff       	jmp    80106da9 <alltraps>

80107d63 <vector231>:
.globl vector231
vector231:
  pushl $0
80107d63:	6a 00                	push   $0x0
  pushl $231
80107d65:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107d6a:	e9 3a f0 ff ff       	jmp    80106da9 <alltraps>

80107d6f <vector232>:
.globl vector232
vector232:
  pushl $0
80107d6f:	6a 00                	push   $0x0
  pushl $232
80107d71:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107d76:	e9 2e f0 ff ff       	jmp    80106da9 <alltraps>

80107d7b <vector233>:
.globl vector233
vector233:
  pushl $0
80107d7b:	6a 00                	push   $0x0
  pushl $233
80107d7d:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107d82:	e9 22 f0 ff ff       	jmp    80106da9 <alltraps>

80107d87 <vector234>:
.globl vector234
vector234:
  pushl $0
80107d87:	6a 00                	push   $0x0
  pushl $234
80107d89:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107d8e:	e9 16 f0 ff ff       	jmp    80106da9 <alltraps>

80107d93 <vector235>:
.globl vector235
vector235:
  pushl $0
80107d93:	6a 00                	push   $0x0
  pushl $235
80107d95:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107d9a:	e9 0a f0 ff ff       	jmp    80106da9 <alltraps>

80107d9f <vector236>:
.globl vector236
vector236:
  pushl $0
80107d9f:	6a 00                	push   $0x0
  pushl $236
80107da1:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107da6:	e9 fe ef ff ff       	jmp    80106da9 <alltraps>

80107dab <vector237>:
.globl vector237
vector237:
  pushl $0
80107dab:	6a 00                	push   $0x0
  pushl $237
80107dad:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107db2:	e9 f2 ef ff ff       	jmp    80106da9 <alltraps>

80107db7 <vector238>:
.globl vector238
vector238:
  pushl $0
80107db7:	6a 00                	push   $0x0
  pushl $238
80107db9:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107dbe:	e9 e6 ef ff ff       	jmp    80106da9 <alltraps>

80107dc3 <vector239>:
.globl vector239
vector239:
  pushl $0
80107dc3:	6a 00                	push   $0x0
  pushl $239
80107dc5:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107dca:	e9 da ef ff ff       	jmp    80106da9 <alltraps>

80107dcf <vector240>:
.globl vector240
vector240:
  pushl $0
80107dcf:	6a 00                	push   $0x0
  pushl $240
80107dd1:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107dd6:	e9 ce ef ff ff       	jmp    80106da9 <alltraps>

80107ddb <vector241>:
.globl vector241
vector241:
  pushl $0
80107ddb:	6a 00                	push   $0x0
  pushl $241
80107ddd:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107de2:	e9 c2 ef ff ff       	jmp    80106da9 <alltraps>

80107de7 <vector242>:
.globl vector242
vector242:
  pushl $0
80107de7:	6a 00                	push   $0x0
  pushl $242
80107de9:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107dee:	e9 b6 ef ff ff       	jmp    80106da9 <alltraps>

80107df3 <vector243>:
.globl vector243
vector243:
  pushl $0
80107df3:	6a 00                	push   $0x0
  pushl $243
80107df5:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107dfa:	e9 aa ef ff ff       	jmp    80106da9 <alltraps>

80107dff <vector244>:
.globl vector244
vector244:
  pushl $0
80107dff:	6a 00                	push   $0x0
  pushl $244
80107e01:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107e06:	e9 9e ef ff ff       	jmp    80106da9 <alltraps>

80107e0b <vector245>:
.globl vector245
vector245:
  pushl $0
80107e0b:	6a 00                	push   $0x0
  pushl $245
80107e0d:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107e12:	e9 92 ef ff ff       	jmp    80106da9 <alltraps>

80107e17 <vector246>:
.globl vector246
vector246:
  pushl $0
80107e17:	6a 00                	push   $0x0
  pushl $246
80107e19:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107e1e:	e9 86 ef ff ff       	jmp    80106da9 <alltraps>

80107e23 <vector247>:
.globl vector247
vector247:
  pushl $0
80107e23:	6a 00                	push   $0x0
  pushl $247
80107e25:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107e2a:	e9 7a ef ff ff       	jmp    80106da9 <alltraps>

80107e2f <vector248>:
.globl vector248
vector248:
  pushl $0
80107e2f:	6a 00                	push   $0x0
  pushl $248
80107e31:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107e36:	e9 6e ef ff ff       	jmp    80106da9 <alltraps>

80107e3b <vector249>:
.globl vector249
vector249:
  pushl $0
80107e3b:	6a 00                	push   $0x0
  pushl $249
80107e3d:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107e42:	e9 62 ef ff ff       	jmp    80106da9 <alltraps>

80107e47 <vector250>:
.globl vector250
vector250:
  pushl $0
80107e47:	6a 00                	push   $0x0
  pushl $250
80107e49:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107e4e:	e9 56 ef ff ff       	jmp    80106da9 <alltraps>

80107e53 <vector251>:
.globl vector251
vector251:
  pushl $0
80107e53:	6a 00                	push   $0x0
  pushl $251
80107e55:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107e5a:	e9 4a ef ff ff       	jmp    80106da9 <alltraps>

80107e5f <vector252>:
.globl vector252
vector252:
  pushl $0
80107e5f:	6a 00                	push   $0x0
  pushl $252
80107e61:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107e66:	e9 3e ef ff ff       	jmp    80106da9 <alltraps>

80107e6b <vector253>:
.globl vector253
vector253:
  pushl $0
80107e6b:	6a 00                	push   $0x0
  pushl $253
80107e6d:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107e72:	e9 32 ef ff ff       	jmp    80106da9 <alltraps>

80107e77 <vector254>:
.globl vector254
vector254:
  pushl $0
80107e77:	6a 00                	push   $0x0
  pushl $254
80107e79:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107e7e:	e9 26 ef ff ff       	jmp    80106da9 <alltraps>

80107e83 <vector255>:
.globl vector255
vector255:
  pushl $0
80107e83:	6a 00                	push   $0x0
  pushl $255
80107e85:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107e8a:	e9 1a ef ff ff       	jmp    80106da9 <alltraps>

80107e8f <lgdt>:
{
80107e8f:	55                   	push   %ebp
80107e90:	89 e5                	mov    %esp,%ebp
80107e92:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107e95:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e98:	83 e8 01             	sub    $0x1,%eax
80107e9b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107e9f:	8b 45 08             	mov    0x8(%ebp),%eax
80107ea2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107ea6:	8b 45 08             	mov    0x8(%ebp),%eax
80107ea9:	c1 e8 10             	shr    $0x10,%eax
80107eac:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107eb0:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107eb3:	0f 01 10             	lgdtl  (%eax)
}
80107eb6:	90                   	nop
80107eb7:	c9                   	leave  
80107eb8:	c3                   	ret    

80107eb9 <ltr>:
{
80107eb9:	55                   	push   %ebp
80107eba:	89 e5                	mov    %esp,%ebp
80107ebc:	83 ec 04             	sub    $0x4,%esp
80107ebf:	8b 45 08             	mov    0x8(%ebp),%eax
80107ec2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107ec6:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107eca:	0f 00 d8             	ltr    %ax
}
80107ecd:	90                   	nop
80107ece:	c9                   	leave  
80107ecf:	c3                   	ret    

80107ed0 <lcr3>:

static inline void
lcr3(uint val)
{
80107ed0:	55                   	push   %ebp
80107ed1:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107ed3:	8b 45 08             	mov    0x8(%ebp),%eax
80107ed6:	0f 22 d8             	mov    %eax,%cr3
}
80107ed9:	90                   	nop
80107eda:	5d                   	pop    %ebp
80107edb:	c3                   	ret    

80107edc <seginit>:
pde_t *kpgdir;      // for use in scheduler()

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void seginit(void)
{
80107edc:	f3 0f 1e fb          	endbr32 
80107ee0:	55                   	push   %ebp
80107ee1:	89 e5                	mov    %esp,%ebp
80107ee3:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107ee6:	e8 d0 c5 ff ff       	call   801044bb <cpuid>
80107eeb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107ef1:	05 20 58 11 80       	add    $0x80115820,%eax
80107ef6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
80107ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107efc:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f05:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f0e:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f15:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f19:	83 e2 f0             	and    $0xfffffff0,%edx
80107f1c:	83 ca 0a             	or     $0xa,%edx
80107f1f:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f25:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f29:	83 ca 10             	or     $0x10,%edx
80107f2c:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f32:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f36:	83 e2 9f             	and    $0xffffff9f,%edx
80107f39:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f3f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f43:	83 ca 80             	or     $0xffffff80,%edx
80107f46:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f4c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f50:	83 ca 0f             	or     $0xf,%edx
80107f53:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f59:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f5d:	83 e2 ef             	and    $0xffffffef,%edx
80107f60:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f66:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f6a:	83 e2 df             	and    $0xffffffdf,%edx
80107f6d:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f73:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f77:	83 ca 40             	or     $0x40,%edx
80107f7a:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f80:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f84:	83 ca 80             	or     $0xffffff80,%edx
80107f87:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f8d:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f94:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107f9b:	ff ff 
80107f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa0:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107fa7:	00 00 
80107fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fac:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb6:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107fbd:	83 e2 f0             	and    $0xfffffff0,%edx
80107fc0:	83 ca 02             	or     $0x2,%edx
80107fc3:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fcc:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107fd3:	83 ca 10             	or     $0x10,%edx
80107fd6:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fdf:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107fe6:	83 e2 9f             	and    $0xffffff9f,%edx
80107fe9:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff2:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107ff9:	83 ca 80             	or     $0xffffff80,%edx
80107ffc:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108002:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108005:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010800c:	83 ca 0f             	or     $0xf,%edx
8010800f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108015:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108018:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010801f:	83 e2 ef             	and    $0xffffffef,%edx
80108022:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108028:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010802b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108032:	83 e2 df             	and    $0xffffffdf,%edx
80108035:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010803b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010803e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108045:	83 ca 40             	or     $0x40,%edx
80108048:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010804e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108051:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108058:	83 ca 80             	or     $0xffffff80,%edx
8010805b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108061:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108064:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
8010806b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010806e:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80108075:	ff ff 
80108077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010807a:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80108081:	00 00 
80108083:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108086:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
8010808d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108090:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108097:	83 e2 f0             	and    $0xfffffff0,%edx
8010809a:	83 ca 0a             	or     $0xa,%edx
8010809d:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801080a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a6:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801080ad:	83 ca 10             	or     $0x10,%edx
801080b0:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801080b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b9:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801080c0:	83 ca 60             	or     $0x60,%edx
801080c3:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801080c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080cc:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801080d3:	83 ca 80             	or     $0xffffff80,%edx
801080d6:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801080dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080df:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801080e6:	83 ca 0f             	or     $0xf,%edx
801080e9:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801080ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f2:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801080f9:	83 e2 ef             	and    $0xffffffef,%edx
801080fc:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108102:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108105:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010810c:	83 e2 df             	and    $0xffffffdf,%edx
8010810f:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108118:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010811f:	83 ca 40             	or     $0x40,%edx
80108122:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108128:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010812b:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108132:	83 ca 80             	or     $0xffffff80,%edx
80108135:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010813b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010813e:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108145:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108148:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010814f:	ff ff 
80108151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108154:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
8010815b:	00 00 
8010815d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108160:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80108167:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010816a:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108171:	83 e2 f0             	and    $0xfffffff0,%edx
80108174:	83 ca 02             	or     $0x2,%edx
80108177:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010817d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108180:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108187:	83 ca 10             	or     $0x10,%edx
8010818a:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108193:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010819a:	83 ca 60             	or     $0x60,%edx
8010819d:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801081a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a6:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801081ad:	83 ca 80             	or     $0xffffff80,%edx
801081b0:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801081b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b9:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801081c0:	83 ca 0f             	or     $0xf,%edx
801081c3:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081cc:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801081d3:	83 e2 ef             	and    $0xffffffef,%edx
801081d6:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081df:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801081e6:	83 e2 df             	and    $0xffffffdf,%edx
801081e9:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f2:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801081f9:	83 ca 40             	or     $0x40,%edx
801081fc:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108202:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108205:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010820c:	83 ca 80             	or     $0xffffff80,%edx
8010820f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108215:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108218:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010821f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108222:	83 c0 70             	add    $0x70,%eax
80108225:	83 ec 08             	sub    $0x8,%esp
80108228:	6a 30                	push   $0x30
8010822a:	50                   	push   %eax
8010822b:	e8 5f fc ff ff       	call   80107e8f <lgdt>
80108230:	83 c4 10             	add    $0x10,%esp
}
80108233:	90                   	nop
80108234:	c9                   	leave  
80108235:	c3                   	ret    

80108236 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108236:	f3 0f 1e fb          	endbr32 
8010823a:	55                   	push   %ebp
8010823b:	89 e5                	mov    %esp,%ebp
8010823d:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108240:	8b 45 0c             	mov    0xc(%ebp),%eax
80108243:	c1 e8 16             	shr    $0x16,%eax
80108246:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010824d:	8b 45 08             	mov    0x8(%ebp),%eax
80108250:	01 d0                	add    %edx,%eax
80108252:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (*pde & PTE_P)
80108255:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108258:	8b 00                	mov    (%eax),%eax
8010825a:	83 e0 01             	and    $0x1,%eax
8010825d:	85 c0                	test   %eax,%eax
8010825f:	74 14                	je     80108275 <walkpgdir+0x3f>
  {
    // if (!alloc)
    // cprintf("page directory is good\n");
    pgtab = (pte_t *)P2V(PTE_ADDR(*pde));
80108261:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108264:	8b 00                	mov    (%eax),%eax
80108266:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010826b:	05 00 00 00 80       	add    $0x80000000,%eax
80108270:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108273:	eb 42                	jmp    801082b7 <walkpgdir+0x81>
  }
  else
  {
    if (!alloc || (pgtab = (pte_t *)kalloc()) == 0)
80108275:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108279:	74 0e                	je     80108289 <walkpgdir+0x53>
8010827b:	e8 9e ab ff ff       	call   80102e1e <kalloc>
80108280:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108283:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108287:	75 07                	jne    80108290 <walkpgdir+0x5a>
      return 0;
80108289:	b8 00 00 00 00       	mov    $0x0,%eax
8010828e:	eb 3e                	jmp    801082ce <walkpgdir+0x98>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108290:	83 ec 04             	sub    $0x4,%esp
80108293:	68 00 10 00 00       	push   $0x1000
80108298:	6a 00                	push   $0x0
8010829a:	ff 75 f4             	pushl  -0xc(%ebp)
8010829d:	e8 a9 d5 ff ff       	call   8010584b <memset>
801082a2:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801082a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a8:	05 00 00 00 80       	add    $0x80000000,%eax
801082ad:	83 c8 07             	or     $0x7,%eax
801082b0:	89 c2                	mov    %eax,%edx
801082b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082b5:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801082b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801082ba:	c1 e8 0c             	shr    $0xc,%eax
801082bd:	25 ff 03 00 00       	and    $0x3ff,%eax
801082c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801082c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082cc:	01 d0                	add    %edx,%eax
}
801082ce:	c9                   	leave  
801082cf:	c3                   	ret    

801082d0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801082d0:	f3 0f 1e fb          	endbr32 
801082d4:	55                   	push   %ebp
801082d5:	89 e5                	mov    %esp,%ebp
801082d7:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char *)PGROUNDDOWN((uint)va);
801082da:	8b 45 0c             	mov    0xc(%ebp),%eax
801082dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
801082e5:	8b 55 0c             	mov    0xc(%ebp),%edx
801082e8:	8b 45 10             	mov    0x10(%ebp),%eax
801082eb:	01 d0                	add    %edx,%eax
801082ed:	83 e8 01             	sub    $0x1,%eax
801082f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (;;)
  {
    if ((pte = walkpgdir(pgdir, a, 1)) == 0)
801082f8:	83 ec 04             	sub    $0x4,%esp
801082fb:	6a 01                	push   $0x1
801082fd:	ff 75 f4             	pushl  -0xc(%ebp)
80108300:	ff 75 08             	pushl  0x8(%ebp)
80108303:	e8 2e ff ff ff       	call   80108236 <walkpgdir>
80108308:	83 c4 10             	add    $0x10,%esp
8010830b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010830e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108312:	75 07                	jne    8010831b <mappages+0x4b>
      return -1;
80108314:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108319:	eb 6a                	jmp    80108385 <mappages+0xb5>
    if (*pte & (PTE_P | PTE_E))
8010831b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010831e:	8b 00                	mov    (%eax),%eax
80108320:	25 01 04 00 00       	and    $0x401,%eax
80108325:	85 c0                	test   %eax,%eax
80108327:	74 0d                	je     80108336 <mappages+0x66>
      panic("p4Debug, remapping page");
80108329:	83 ec 0c             	sub    $0xc,%esp
8010832c:	68 94 9e 10 80       	push   $0x80109e94
80108331:	e8 d2 82 ff ff       	call   80100608 <panic>

    if (perm & PTE_E)
80108336:	8b 45 18             	mov    0x18(%ebp),%eax
80108339:	25 00 04 00 00       	and    $0x400,%eax
8010833e:	85 c0                	test   %eax,%eax
80108340:	74 12                	je     80108354 <mappages+0x84>
      *pte = pa | perm | PTE_E;
80108342:	8b 45 18             	mov    0x18(%ebp),%eax
80108345:	0b 45 14             	or     0x14(%ebp),%eax
80108348:	80 cc 04             	or     $0x4,%ah
8010834b:	89 c2                	mov    %eax,%edx
8010834d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108350:	89 10                	mov    %edx,(%eax)
80108352:	eb 10                	jmp    80108364 <mappages+0x94>
    else
      *pte = pa | perm | PTE_P;
80108354:	8b 45 18             	mov    0x18(%ebp),%eax
80108357:	0b 45 14             	or     0x14(%ebp),%eax
8010835a:	83 c8 01             	or     $0x1,%eax
8010835d:	89 c2                	mov    %eax,%edx
8010835f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108362:	89 10                	mov    %edx,(%eax)

    if (a == last)
80108364:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108367:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010836a:	74 13                	je     8010837f <mappages+0xaf>
      break;
    a += PGSIZE;
8010836c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108373:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if ((pte = walkpgdir(pgdir, a, 1)) == 0)
8010837a:	e9 79 ff ff ff       	jmp    801082f8 <mappages+0x28>
      break;
8010837f:	90                   	nop
  }
  return 0;
80108380:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108385:	c9                   	leave  
80108386:	c3                   	ret    

80108387 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t *
setupkvm(void)
{
80108387:	f3 0f 1e fb          	endbr32 
8010838b:	55                   	push   %ebp
8010838c:	89 e5                	mov    %esp,%ebp
8010838e:	53                   	push   %ebx
8010838f:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if ((pgdir = (pde_t *)kalloc()) == 0)
80108392:	e8 87 aa ff ff       	call   80102e1e <kalloc>
80108397:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010839a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010839e:	75 07                	jne    801083a7 <setupkvm+0x20>
    return 0;
801083a0:	b8 00 00 00 00       	mov    $0x0,%eax
801083a5:	eb 78                	jmp    8010841f <setupkvm+0x98>
  memset(pgdir, 0, PGSIZE);
801083a7:	83 ec 04             	sub    $0x4,%esp
801083aa:	68 00 10 00 00       	push   $0x1000
801083af:	6a 00                	push   $0x0
801083b1:	ff 75 f0             	pushl  -0x10(%ebp)
801083b4:	e8 92 d4 ff ff       	call   8010584b <memset>
801083b9:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void *)DEVSPACE)
    panic("PHYSTOP too high");
  for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
801083bc:	c7 45 f4 a0 d4 10 80 	movl   $0x8010d4a0,-0xc(%ebp)
801083c3:	eb 4e                	jmp    80108413 <setupkvm+0x8c>
    if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801083c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083c8:	8b 48 0c             	mov    0xc(%eax),%ecx
                 (uint)k->phys_start, k->perm) < 0)
801083cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083ce:	8b 50 04             	mov    0x4(%eax),%edx
    if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801083d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083d4:	8b 58 08             	mov    0x8(%eax),%ebx
801083d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083da:	8b 40 04             	mov    0x4(%eax),%eax
801083dd:	29 c3                	sub    %eax,%ebx
801083df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083e2:	8b 00                	mov    (%eax),%eax
801083e4:	83 ec 0c             	sub    $0xc,%esp
801083e7:	51                   	push   %ecx
801083e8:	52                   	push   %edx
801083e9:	53                   	push   %ebx
801083ea:	50                   	push   %eax
801083eb:	ff 75 f0             	pushl  -0x10(%ebp)
801083ee:	e8 dd fe ff ff       	call   801082d0 <mappages>
801083f3:	83 c4 20             	add    $0x20,%esp
801083f6:	85 c0                	test   %eax,%eax
801083f8:	79 15                	jns    8010840f <setupkvm+0x88>
    {
      freevm(pgdir);
801083fa:	83 ec 0c             	sub    $0xc,%esp
801083fd:	ff 75 f0             	pushl  -0x10(%ebp)
80108400:	e8 13 05 00 00       	call   80108918 <freevm>
80108405:	83 c4 10             	add    $0x10,%esp
      return 0;
80108408:	b8 00 00 00 00       	mov    $0x0,%eax
8010840d:	eb 10                	jmp    8010841f <setupkvm+0x98>
  for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010840f:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108413:	81 7d f4 e0 d4 10 80 	cmpl   $0x8010d4e0,-0xc(%ebp)
8010841a:	72 a9                	jb     801083c5 <setupkvm+0x3e>
    }
  return pgdir;
8010841c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010841f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108422:	c9                   	leave  
80108423:	c3                   	ret    

80108424 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void kvmalloc(void)
{
80108424:	f3 0f 1e fb          	endbr32 
80108428:	55                   	push   %ebp
80108429:	89 e5                	mov    %esp,%ebp
8010842b:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010842e:	e8 54 ff ff ff       	call   80108387 <setupkvm>
80108433:	a3 44 9f 11 80       	mov    %eax,0x80119f44
  switchkvm();
80108438:	e8 03 00 00 00       	call   80108440 <switchkvm>
}
8010843d:	90                   	nop
8010843e:	c9                   	leave  
8010843f:	c3                   	ret    

80108440 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void switchkvm(void)
{
80108440:	f3 0f 1e fb          	endbr32 
80108444:	55                   	push   %ebp
80108445:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir)); // switch to the kernel page table
80108447:	a1 44 9f 11 80       	mov    0x80119f44,%eax
8010844c:	05 00 00 00 80       	add    $0x80000000,%eax
80108451:	50                   	push   %eax
80108452:	e8 79 fa ff ff       	call   80107ed0 <lcr3>
80108457:	83 c4 04             	add    $0x4,%esp
}
8010845a:	90                   	nop
8010845b:	c9                   	leave  
8010845c:	c3                   	ret    

8010845d <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void switchuvm(struct proc *p)
{
8010845d:	f3 0f 1e fb          	endbr32 
80108461:	55                   	push   %ebp
80108462:	89 e5                	mov    %esp,%ebp
80108464:	56                   	push   %esi
80108465:	53                   	push   %ebx
80108466:	83 ec 10             	sub    $0x10,%esp
  if (p == 0)
80108469:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010846d:	75 0d                	jne    8010847c <switchuvm+0x1f>
    panic("switchuvm: no process");
8010846f:	83 ec 0c             	sub    $0xc,%esp
80108472:	68 ac 9e 10 80       	push   $0x80109eac
80108477:	e8 8c 81 ff ff       	call   80100608 <panic>
  if (p->kstack == 0)
8010847c:	8b 45 08             	mov    0x8(%ebp),%eax
8010847f:	8b 40 08             	mov    0x8(%eax),%eax
80108482:	85 c0                	test   %eax,%eax
80108484:	75 0d                	jne    80108493 <switchuvm+0x36>
    panic("switchuvm: no kstack");
80108486:	83 ec 0c             	sub    $0xc,%esp
80108489:	68 c2 9e 10 80       	push   $0x80109ec2
8010848e:	e8 75 81 ff ff       	call   80100608 <panic>
  if (p->pgdir == 0)
80108493:	8b 45 08             	mov    0x8(%ebp),%eax
80108496:	8b 40 04             	mov    0x4(%eax),%eax
80108499:	85 c0                	test   %eax,%eax
8010849b:	75 0d                	jne    801084aa <switchuvm+0x4d>
    panic("switchuvm: no pgdir");
8010849d:	83 ec 0c             	sub    $0xc,%esp
801084a0:	68 d7 9e 10 80       	push   $0x80109ed7
801084a5:	e8 5e 81 ff ff       	call   80100608 <panic>

  pushcli();
801084aa:	e8 89 d2 ff ff       	call   80105738 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801084af:	e8 26 c0 ff ff       	call   801044da <mycpu>
801084b4:	89 c3                	mov    %eax,%ebx
801084b6:	e8 1f c0 ff ff       	call   801044da <mycpu>
801084bb:	83 c0 08             	add    $0x8,%eax
801084be:	89 c6                	mov    %eax,%esi
801084c0:	e8 15 c0 ff ff       	call   801044da <mycpu>
801084c5:	83 c0 08             	add    $0x8,%eax
801084c8:	c1 e8 10             	shr    $0x10,%eax
801084cb:	88 45 f7             	mov    %al,-0x9(%ebp)
801084ce:	e8 07 c0 ff ff       	call   801044da <mycpu>
801084d3:	83 c0 08             	add    $0x8,%eax
801084d6:	c1 e8 18             	shr    $0x18,%eax
801084d9:	89 c2                	mov    %eax,%edx
801084db:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801084e2:	67 00 
801084e4:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
801084eb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
801084ef:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
801084f5:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801084fc:	83 e0 f0             	and    $0xfffffff0,%eax
801084ff:	83 c8 09             	or     $0x9,%eax
80108502:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80108508:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
8010850f:	83 c8 10             	or     $0x10,%eax
80108512:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80108518:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
8010851f:	83 e0 9f             	and    $0xffffff9f,%eax
80108522:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80108528:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
8010852f:	83 c8 80             	or     $0xffffff80,%eax
80108532:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80108538:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
8010853f:	83 e0 f0             	and    $0xfffffff0,%eax
80108542:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80108548:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
8010854f:	83 e0 ef             	and    $0xffffffef,%eax
80108552:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80108558:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
8010855f:	83 e0 df             	and    $0xffffffdf,%eax
80108562:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80108568:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
8010856f:	83 c8 40             	or     $0x40,%eax
80108572:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80108578:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
8010857f:	83 e0 7f             	and    $0x7f,%eax
80108582:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80108588:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts) - 1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010858e:	e8 47 bf ff ff       	call   801044da <mycpu>
80108593:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010859a:	83 e2 ef             	and    $0xffffffef,%edx
8010859d:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801085a3:	e8 32 bf ff ff       	call   801044da <mycpu>
801085a8:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801085ae:	8b 45 08             	mov    0x8(%ebp),%eax
801085b1:	8b 40 08             	mov    0x8(%eax),%eax
801085b4:	89 c3                	mov    %eax,%ebx
801085b6:	e8 1f bf ff ff       	call   801044da <mycpu>
801085bb:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
801085c1:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort)0xFFFF;
801085c4:	e8 11 bf ff ff       	call   801044da <mycpu>
801085c9:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
801085cf:	83 ec 0c             	sub    $0xc,%esp
801085d2:	6a 28                	push   $0x28
801085d4:	e8 e0 f8 ff ff       	call   80107eb9 <ltr>
801085d9:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir)); // switch to process's address space
801085dc:	8b 45 08             	mov    0x8(%ebp),%eax
801085df:	8b 40 04             	mov    0x4(%eax),%eax
801085e2:	05 00 00 00 80       	add    $0x80000000,%eax
801085e7:	83 ec 0c             	sub    $0xc,%esp
801085ea:	50                   	push   %eax
801085eb:	e8 e0 f8 ff ff       	call   80107ed0 <lcr3>
801085f0:	83 c4 10             	add    $0x10,%esp
  popcli();
801085f3:	e8 91 d1 ff ff       	call   80105789 <popcli>
}
801085f8:	90                   	nop
801085f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801085fc:	5b                   	pop    %ebx
801085fd:	5e                   	pop    %esi
801085fe:	5d                   	pop    %ebp
801085ff:	c3                   	ret    

80108600 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void inituvm(pde_t *pgdir, char *init, uint sz)
{
80108600:	f3 0f 1e fb          	endbr32 
80108604:	55                   	push   %ebp
80108605:	89 e5                	mov    %esp,%ebp
80108607:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if (sz >= PGSIZE)
8010860a:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108611:	76 0d                	jbe    80108620 <inituvm+0x20>
    panic("inituvm: more than a page");
80108613:	83 ec 0c             	sub    $0xc,%esp
80108616:	68 eb 9e 10 80       	push   $0x80109eeb
8010861b:	e8 e8 7f ff ff       	call   80100608 <panic>
  mem = kalloc();
80108620:	e8 f9 a7 ff ff       	call   80102e1e <kalloc>
80108625:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108628:	83 ec 04             	sub    $0x4,%esp
8010862b:	68 00 10 00 00       	push   $0x1000
80108630:	6a 00                	push   $0x0
80108632:	ff 75 f4             	pushl  -0xc(%ebp)
80108635:	e8 11 d2 ff ff       	call   8010584b <memset>
8010863a:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
8010863d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108640:	05 00 00 00 80       	add    $0x80000000,%eax
80108645:	83 ec 0c             	sub    $0xc,%esp
80108648:	6a 06                	push   $0x6
8010864a:	50                   	push   %eax
8010864b:	68 00 10 00 00       	push   $0x1000
80108650:	6a 00                	push   $0x0
80108652:	ff 75 08             	pushl  0x8(%ebp)
80108655:	e8 76 fc ff ff       	call   801082d0 <mappages>
8010865a:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
8010865d:	83 ec 04             	sub    $0x4,%esp
80108660:	ff 75 10             	pushl  0x10(%ebp)
80108663:	ff 75 0c             	pushl  0xc(%ebp)
80108666:	ff 75 f4             	pushl  -0xc(%ebp)
80108669:	e8 a4 d2 ff ff       	call   80105912 <memmove>
8010866e:	83 c4 10             	add    $0x10,%esp
}
80108671:	90                   	nop
80108672:	c9                   	leave  
80108673:	c3                   	ret    

80108674 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108674:	f3 0f 1e fb          	endbr32 
80108678:	55                   	push   %ebp
80108679:	89 e5                	mov    %esp,%ebp
8010867b:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if ((uint)addr % PGSIZE != 0)
8010867e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108681:	25 ff 0f 00 00       	and    $0xfff,%eax
80108686:	85 c0                	test   %eax,%eax
80108688:	74 0d                	je     80108697 <loaduvm+0x23>
    panic("loaduvm: addr must be page aligned");
8010868a:	83 ec 0c             	sub    $0xc,%esp
8010868d:	68 08 9f 10 80       	push   $0x80109f08
80108692:	e8 71 7f ff ff       	call   80100608 <panic>
  for (i = 0; i < sz; i += PGSIZE)
80108697:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010869e:	e9 8f 00 00 00       	jmp    80108732 <loaduvm+0xbe>
  {
    if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0)
801086a3:	8b 55 0c             	mov    0xc(%ebp),%edx
801086a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086a9:	01 d0                	add    %edx,%eax
801086ab:	83 ec 04             	sub    $0x4,%esp
801086ae:	6a 00                	push   $0x0
801086b0:	50                   	push   %eax
801086b1:	ff 75 08             	pushl  0x8(%ebp)
801086b4:	e8 7d fb ff ff       	call   80108236 <walkpgdir>
801086b9:	83 c4 10             	add    $0x10,%esp
801086bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
801086bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801086c3:	75 0d                	jne    801086d2 <loaduvm+0x5e>
      panic("loaduvm: address should exist");
801086c5:	83 ec 0c             	sub    $0xc,%esp
801086c8:	68 2b 9f 10 80       	push   $0x80109f2b
801086cd:	e8 36 7f ff ff       	call   80100608 <panic>
    pa = PTE_ADDR(*pte);
801086d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086d5:	8b 00                	mov    (%eax),%eax
801086d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (sz - i < PGSIZE)
801086df:	8b 45 18             	mov    0x18(%ebp),%eax
801086e2:	2b 45 f4             	sub    -0xc(%ebp),%eax
801086e5:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801086ea:	77 0b                	ja     801086f7 <loaduvm+0x83>
      n = sz - i;
801086ec:	8b 45 18             	mov    0x18(%ebp),%eax
801086ef:	2b 45 f4             	sub    -0xc(%ebp),%eax
801086f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801086f5:	eb 07                	jmp    801086fe <loaduvm+0x8a>
    else
      n = PGSIZE;
801086f7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if (readi(ip, P2V(pa), offset + i, n) != n)
801086fe:	8b 55 14             	mov    0x14(%ebp),%edx
80108701:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108704:	01 d0                	add    %edx,%eax
80108706:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108709:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010870f:	ff 75 f0             	pushl  -0x10(%ebp)
80108712:	50                   	push   %eax
80108713:	52                   	push   %edx
80108714:	ff 75 10             	pushl  0x10(%ebp)
80108717:	e8 1a 99 ff ff       	call   80102036 <readi>
8010871c:	83 c4 10             	add    $0x10,%esp
8010871f:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80108722:	74 07                	je     8010872b <loaduvm+0xb7>
      return -1;
80108724:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108729:	eb 18                	jmp    80108743 <loaduvm+0xcf>
  for (i = 0; i < sz; i += PGSIZE)
8010872b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108732:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108735:	3b 45 18             	cmp    0x18(%ebp),%eax
80108738:	0f 82 65 ff ff ff    	jb     801086a3 <loaduvm+0x2f>
  }
  return 0;
8010873e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108743:	c9                   	leave  
80108744:	c3                   	ret    

80108745 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108745:	f3 0f 1e fb          	endbr32 
80108749:	55                   	push   %ebp
8010874a:	89 e5                	mov    %esp,%ebp
8010874c:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if (newsz >= KERNBASE)
8010874f:	8b 45 10             	mov    0x10(%ebp),%eax
80108752:	85 c0                	test   %eax,%eax
80108754:	79 0a                	jns    80108760 <allocuvm+0x1b>
    return 0;
80108756:	b8 00 00 00 00       	mov    $0x0,%eax
8010875b:	e9 ec 00 00 00       	jmp    8010884c <allocuvm+0x107>
  if (newsz < oldsz)
80108760:	8b 45 10             	mov    0x10(%ebp),%eax
80108763:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108766:	73 08                	jae    80108770 <allocuvm+0x2b>
    return oldsz;
80108768:	8b 45 0c             	mov    0xc(%ebp),%eax
8010876b:	e9 dc 00 00 00       	jmp    8010884c <allocuvm+0x107>

  a = PGROUNDUP(oldsz);
80108770:	8b 45 0c             	mov    0xc(%ebp),%eax
80108773:	05 ff 0f 00 00       	add    $0xfff,%eax
80108778:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010877d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for (; a < newsz; a += PGSIZE)
80108780:	e9 b8 00 00 00       	jmp    8010883d <allocuvm+0xf8>
  {
    mem = kalloc();
80108785:	e8 94 a6 ff ff       	call   80102e1e <kalloc>
8010878a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (mem == 0)
8010878d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108791:	75 2e                	jne    801087c1 <allocuvm+0x7c>
    {
      cprintf("allocuvm out of memory\n");
80108793:	83 ec 0c             	sub    $0xc,%esp
80108796:	68 49 9f 10 80       	push   $0x80109f49
8010879b:	e8 78 7c ff ff       	call   80100418 <cprintf>
801087a0:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801087a3:	83 ec 04             	sub    $0x4,%esp
801087a6:	ff 75 0c             	pushl  0xc(%ebp)
801087a9:	ff 75 10             	pushl  0x10(%ebp)
801087ac:	ff 75 08             	pushl  0x8(%ebp)
801087af:	e8 9a 00 00 00       	call   8010884e <deallocuvm>
801087b4:	83 c4 10             	add    $0x10,%esp
      return 0;
801087b7:	b8 00 00 00 00       	mov    $0x0,%eax
801087bc:	e9 8b 00 00 00       	jmp    8010884c <allocuvm+0x107>
    }
    memset(mem, 0, PGSIZE);
801087c1:	83 ec 04             	sub    $0x4,%esp
801087c4:	68 00 10 00 00       	push   $0x1000
801087c9:	6a 00                	push   $0x0
801087cb:	ff 75 f0             	pushl  -0x10(%ebp)
801087ce:	e8 78 d0 ff ff       	call   8010584b <memset>
801087d3:	83 c4 10             	add    $0x10,%esp
    if (mappages(pgdir, (char *)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0)
801087d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087d9:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801087df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087e2:	83 ec 0c             	sub    $0xc,%esp
801087e5:	6a 06                	push   $0x6
801087e7:	52                   	push   %edx
801087e8:	68 00 10 00 00       	push   $0x1000
801087ed:	50                   	push   %eax
801087ee:	ff 75 08             	pushl  0x8(%ebp)
801087f1:	e8 da fa ff ff       	call   801082d0 <mappages>
801087f6:	83 c4 20             	add    $0x20,%esp
801087f9:	85 c0                	test   %eax,%eax
801087fb:	79 39                	jns    80108836 <allocuvm+0xf1>
    {
      cprintf("allocuvm out of memory (2)\n");
801087fd:	83 ec 0c             	sub    $0xc,%esp
80108800:	68 61 9f 10 80       	push   $0x80109f61
80108805:	e8 0e 7c ff ff       	call   80100418 <cprintf>
8010880a:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
8010880d:	83 ec 04             	sub    $0x4,%esp
80108810:	ff 75 0c             	pushl  0xc(%ebp)
80108813:	ff 75 10             	pushl  0x10(%ebp)
80108816:	ff 75 08             	pushl  0x8(%ebp)
80108819:	e8 30 00 00 00       	call   8010884e <deallocuvm>
8010881e:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
80108821:	83 ec 0c             	sub    $0xc,%esp
80108824:	ff 75 f0             	pushl  -0x10(%ebp)
80108827:	e8 54 a5 ff ff       	call   80102d80 <kfree>
8010882c:	83 c4 10             	add    $0x10,%esp
      return 0;
8010882f:	b8 00 00 00 00       	mov    $0x0,%eax
80108834:	eb 16                	jmp    8010884c <allocuvm+0x107>
  for (; a < newsz; a += PGSIZE)
80108836:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010883d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108840:	3b 45 10             	cmp    0x10(%ebp),%eax
80108843:	0f 82 3c ff ff ff    	jb     80108785 <allocuvm+0x40>
    }
  }
  return newsz;
80108849:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010884c:	c9                   	leave  
8010884d:	c3                   	ret    

8010884e <deallocuvm>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010884e:	f3 0f 1e fb          	endbr32 
80108852:	55                   	push   %ebp
80108853:	89 e5                	mov    %esp,%ebp
80108855:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if (newsz >= oldsz)
80108858:	8b 45 10             	mov    0x10(%ebp),%eax
8010885b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010885e:	72 08                	jb     80108868 <deallocuvm+0x1a>
    return oldsz;
80108860:	8b 45 0c             	mov    0xc(%ebp),%eax
80108863:	e9 ae 00 00 00       	jmp    80108916 <deallocuvm+0xc8>

  a = PGROUNDUP(newsz);
80108868:	8b 45 10             	mov    0x10(%ebp),%eax
8010886b:	05 ff 0f 00 00       	add    $0xfff,%eax
80108870:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108875:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for (; a < oldsz; a += PGSIZE)
80108878:	e9 8a 00 00 00       	jmp    80108907 <deallocuvm+0xb9>
  {
    pte = walkpgdir(pgdir, (char *)a, 0);
8010887d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108880:	83 ec 04             	sub    $0x4,%esp
80108883:	6a 00                	push   $0x0
80108885:	50                   	push   %eax
80108886:	ff 75 08             	pushl  0x8(%ebp)
80108889:	e8 a8 f9 ff ff       	call   80108236 <walkpgdir>
8010888e:	83 c4 10             	add    $0x10,%esp
80108891:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (!pte)
80108894:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108898:	75 16                	jne    801088b0 <deallocuvm+0x62>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010889a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010889d:	c1 e8 16             	shr    $0x16,%eax
801088a0:	83 c0 01             	add    $0x1,%eax
801088a3:	c1 e0 16             	shl    $0x16,%eax
801088a6:	2d 00 10 00 00       	sub    $0x1000,%eax
801088ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
801088ae:	eb 50                	jmp    80108900 <deallocuvm+0xb2>
    else if ((*pte & (PTE_P | PTE_E)) != 0)
801088b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088b3:	8b 00                	mov    (%eax),%eax
801088b5:	25 01 04 00 00       	and    $0x401,%eax
801088ba:	85 c0                	test   %eax,%eax
801088bc:	74 42                	je     80108900 <deallocuvm+0xb2>
    {
      pa = PTE_ADDR(*pte);
801088be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088c1:	8b 00                	mov    (%eax),%eax
801088c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if (pa == 0)
801088cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801088cf:	75 0d                	jne    801088de <deallocuvm+0x90>
        panic("kfree");
801088d1:	83 ec 0c             	sub    $0xc,%esp
801088d4:	68 7d 9f 10 80       	push   $0x80109f7d
801088d9:	e8 2a 7d ff ff       	call   80100608 <panic>
      char *v = P2V(pa);
801088de:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088e1:	05 00 00 00 80       	add    $0x80000000,%eax
801088e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801088e9:	83 ec 0c             	sub    $0xc,%esp
801088ec:	ff 75 e8             	pushl  -0x18(%ebp)
801088ef:	e8 8c a4 ff ff       	call   80102d80 <kfree>
801088f4:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801088f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for (; a < oldsz; a += PGSIZE)
80108900:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010890a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010890d:	0f 82 6a ff ff ff    	jb     8010887d <deallocuvm+0x2f>
    }
  }
  return newsz;
80108913:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108916:	c9                   	leave  
80108917:	c3                   	ret    

80108918 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void freevm(pde_t *pgdir)
{
80108918:	f3 0f 1e fb          	endbr32 
8010891c:	55                   	push   %ebp
8010891d:	89 e5                	mov    %esp,%ebp
8010891f:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if (pgdir == 0)
80108922:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108926:	75 0d                	jne    80108935 <freevm+0x1d>
    panic("freevm: no pgdir");
80108928:	83 ec 0c             	sub    $0xc,%esp
8010892b:	68 83 9f 10 80       	push   $0x80109f83
80108930:	e8 d3 7c ff ff       	call   80100608 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108935:	83 ec 04             	sub    $0x4,%esp
80108938:	6a 00                	push   $0x0
8010893a:	68 00 00 00 80       	push   $0x80000000
8010893f:	ff 75 08             	pushl  0x8(%ebp)
80108942:	e8 07 ff ff ff       	call   8010884e <deallocuvm>
80108947:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < NPDENTRIES; i++)
8010894a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108951:	eb 4a                	jmp    8010899d <freevm+0x85>
  {
    if (pgdir[i] & (PTE_P | PTE_E))
80108953:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108956:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010895d:	8b 45 08             	mov    0x8(%ebp),%eax
80108960:	01 d0                	add    %edx,%eax
80108962:	8b 00                	mov    (%eax),%eax
80108964:	25 01 04 00 00       	and    $0x401,%eax
80108969:	85 c0                	test   %eax,%eax
8010896b:	74 2c                	je     80108999 <freevm+0x81>
    {
      char *v = P2V(PTE_ADDR(pgdir[i]));
8010896d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108970:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108977:	8b 45 08             	mov    0x8(%ebp),%eax
8010897a:	01 d0                	add    %edx,%eax
8010897c:	8b 00                	mov    (%eax),%eax
8010897e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108983:	05 00 00 00 80       	add    $0x80000000,%eax
80108988:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
8010898b:	83 ec 0c             	sub    $0xc,%esp
8010898e:	ff 75 f0             	pushl  -0x10(%ebp)
80108991:	e8 ea a3 ff ff       	call   80102d80 <kfree>
80108996:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < NPDENTRIES; i++)
80108999:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010899d:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801089a4:	76 ad                	jbe    80108953 <freevm+0x3b>
    }
  }
  kfree((char *)pgdir);
801089a6:	83 ec 0c             	sub    $0xc,%esp
801089a9:	ff 75 08             	pushl  0x8(%ebp)
801089ac:	e8 cf a3 ff ff       	call   80102d80 <kfree>
801089b1:	83 c4 10             	add    $0x10,%esp
}
801089b4:	90                   	nop
801089b5:	c9                   	leave  
801089b6:	c3                   	ret    

801089b7 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void clearpteu(pde_t *pgdir, char *uva)
{
801089b7:	f3 0f 1e fb          	endbr32 
801089bb:	55                   	push   %ebp
801089bc:	89 e5                	mov    %esp,%ebp
801089be:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801089c1:	83 ec 04             	sub    $0x4,%esp
801089c4:	6a 00                	push   $0x0
801089c6:	ff 75 0c             	pushl  0xc(%ebp)
801089c9:	ff 75 08             	pushl  0x8(%ebp)
801089cc:	e8 65 f8 ff ff       	call   80108236 <walkpgdir>
801089d1:	83 c4 10             	add    $0x10,%esp
801089d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (pte == 0)
801089d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801089db:	75 0d                	jne    801089ea <clearpteu+0x33>
    panic("clearpteu");
801089dd:	83 ec 0c             	sub    $0xc,%esp
801089e0:	68 94 9f 10 80       	push   $0x80109f94
801089e5:	e8 1e 7c ff ff       	call   80100608 <panic>
  *pte &= ~PTE_U;
801089ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089ed:	8b 00                	mov    (%eax),%eax
801089ef:	83 e0 fb             	and    $0xfffffffb,%eax
801089f2:	89 c2                	mov    %eax,%edx
801089f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089f7:	89 10                	mov    %edx,(%eax)
}
801089f9:	90                   	nop
801089fa:	c9                   	leave  
801089fb:	c3                   	ret    

801089fc <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t *
copyuvm(pde_t *pgdir, uint sz)
{
801089fc:	f3 0f 1e fb          	endbr32 
80108a00:	55                   	push   %ebp
80108a01:	89 e5                	mov    %esp,%ebp
80108a03:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if ((d = setupkvm()) == 0)
80108a06:	e8 7c f9 ff ff       	call   80108387 <setupkvm>
80108a0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108a0e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108a12:	75 0a                	jne    80108a1e <copyuvm+0x22>
    return 0;
80108a14:	b8 00 00 00 00       	mov    $0x0,%eax
80108a19:	e9 fa 00 00 00       	jmp    80108b18 <copyuvm+0x11c>
  for (i = 0; i < sz; i += PGSIZE)
80108a1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108a25:	e9 c9 00 00 00       	jmp    80108af3 <copyuvm+0xf7>
  {
    if ((pte = walkpgdir(pgdir, (void *)i, 0)) == 0)
80108a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a2d:	83 ec 04             	sub    $0x4,%esp
80108a30:	6a 00                	push   $0x0
80108a32:	50                   	push   %eax
80108a33:	ff 75 08             	pushl  0x8(%ebp)
80108a36:	e8 fb f7 ff ff       	call   80108236 <walkpgdir>
80108a3b:	83 c4 10             	add    $0x10,%esp
80108a3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108a41:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108a45:	75 0d                	jne    80108a54 <copyuvm+0x58>
      panic("p4Debug: inside copyuvm, pte should exist");
80108a47:	83 ec 0c             	sub    $0xc,%esp
80108a4a:	68 a0 9f 10 80       	push   $0x80109fa0
80108a4f:	e8 b4 7b ff ff       	call   80100608 <panic>
    if (!(*pte & (PTE_P | PTE_E)))
80108a54:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a57:	8b 00                	mov    (%eax),%eax
80108a59:	25 01 04 00 00       	and    $0x401,%eax
80108a5e:	85 c0                	test   %eax,%eax
80108a60:	75 0d                	jne    80108a6f <copyuvm+0x73>
      panic("p4Debug: inside copyuvm, page not present");
80108a62:	83 ec 0c             	sub    $0xc,%esp
80108a65:	68 cc 9f 10 80       	push   $0x80109fcc
80108a6a:	e8 99 7b ff ff       	call   80100608 <panic>
    pa = PTE_ADDR(*pte);
80108a6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a72:	8b 00                	mov    (%eax),%eax
80108a74:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a79:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108a7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a7f:	8b 00                	mov    (%eax),%eax
80108a81:	25 ff 0f 00 00       	and    $0xfff,%eax
80108a86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if ((mem = kalloc()) == 0)
80108a89:	e8 90 a3 ff ff       	call   80102e1e <kalloc>
80108a8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108a91:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108a95:	74 6d                	je     80108b04 <copyuvm+0x108>
      goto bad;
    memmove(mem, (char *)P2V(pa), PGSIZE);
80108a97:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a9a:	05 00 00 00 80       	add    $0x80000000,%eax
80108a9f:	83 ec 04             	sub    $0x4,%esp
80108aa2:	68 00 10 00 00       	push   $0x1000
80108aa7:	50                   	push   %eax
80108aa8:	ff 75 e0             	pushl  -0x20(%ebp)
80108aab:	e8 62 ce ff ff       	call   80105912 <memmove>
80108ab0:	83 c4 10             	add    $0x10,%esp
    if (mappages(d, (void *)i, PGSIZE, V2P(mem), flags) < 0)
80108ab3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108ab6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108ab9:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80108abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ac2:	83 ec 0c             	sub    $0xc,%esp
80108ac5:	52                   	push   %edx
80108ac6:	51                   	push   %ecx
80108ac7:	68 00 10 00 00       	push   $0x1000
80108acc:	50                   	push   %eax
80108acd:	ff 75 f0             	pushl  -0x10(%ebp)
80108ad0:	e8 fb f7 ff ff       	call   801082d0 <mappages>
80108ad5:	83 c4 20             	add    $0x20,%esp
80108ad8:	85 c0                	test   %eax,%eax
80108ada:	79 10                	jns    80108aec <copyuvm+0xf0>
    {
      kfree(mem);
80108adc:	83 ec 0c             	sub    $0xc,%esp
80108adf:	ff 75 e0             	pushl  -0x20(%ebp)
80108ae2:	e8 99 a2 ff ff       	call   80102d80 <kfree>
80108ae7:	83 c4 10             	add    $0x10,%esp
      goto bad;
80108aea:	eb 19                	jmp    80108b05 <copyuvm+0x109>
  for (i = 0; i < sz; i += PGSIZE)
80108aec:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108af6:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108af9:	0f 82 2b ff ff ff    	jb     80108a2a <copyuvm+0x2e>
    }
  }
  return d;
80108aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b02:	eb 14                	jmp    80108b18 <copyuvm+0x11c>
      goto bad;
80108b04:	90                   	nop

bad:
  freevm(d);
80108b05:	83 ec 0c             	sub    $0xc,%esp
80108b08:	ff 75 f0             	pushl  -0x10(%ebp)
80108b0b:	e8 08 fe ff ff       	call   80108918 <freevm>
80108b10:	83 c4 10             	add    $0x10,%esp
  return 0;
80108b13:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108b18:	c9                   	leave  
80108b19:	c3                   	ret    

80108b1a <uva2ka>:

// PAGEBREAK!
//  Map user virtual address to kernel address.
char *
uva2ka(pde_t *pgdir, char *uva)
{
80108b1a:	f3 0f 1e fb          	endbr32 
80108b1e:	55                   	push   %ebp
80108b1f:	89 e5                	mov    %esp,%ebp
80108b21:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108b24:	83 ec 04             	sub    $0x4,%esp
80108b27:	6a 00                	push   $0x0
80108b29:	ff 75 0c             	pushl  0xc(%ebp)
80108b2c:	ff 75 08             	pushl  0x8(%ebp)
80108b2f:	e8 02 f7 ff ff       	call   80108236 <walkpgdir>
80108b34:	83 c4 10             	add    $0x10,%esp
80108b37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  // p4Debug: Check for page's present and encrypted flags.
  if (((*pte & PTE_P) | (*pte & PTE_E)) == 0)
80108b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b3d:	8b 00                	mov    (%eax),%eax
80108b3f:	25 01 04 00 00       	and    $0x401,%eax
80108b44:	85 c0                	test   %eax,%eax
80108b46:	75 07                	jne    80108b4f <uva2ka+0x35>
    return 0;
80108b48:	b8 00 00 00 00       	mov    $0x0,%eax
80108b4d:	eb 22                	jmp    80108b71 <uva2ka+0x57>
  if ((*pte & PTE_U) == 0)
80108b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b52:	8b 00                	mov    (%eax),%eax
80108b54:	83 e0 04             	and    $0x4,%eax
80108b57:	85 c0                	test   %eax,%eax
80108b59:	75 07                	jne    80108b62 <uva2ka+0x48>
    return 0;
80108b5b:	b8 00 00 00 00       	mov    $0x0,%eax
80108b60:	eb 0f                	jmp    80108b71 <uva2ka+0x57>
  return (char *)P2V(PTE_ADDR(*pte));
80108b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b65:	8b 00                	mov    (%eax),%eax
80108b67:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b6c:	05 00 00 00 80       	add    $0x80000000,%eax
}
80108b71:	c9                   	leave  
80108b72:	c3                   	ret    

80108b73 <copyout>:

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108b73:	f3 0f 1e fb          	endbr32 
80108b77:	55                   	push   %ebp
80108b78:	89 e5                	mov    %esp,%ebp
80108b7a:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char *)p;
80108b7d:	8b 45 10             	mov    0x10(%ebp),%eax
80108b80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (len > 0)
80108b83:	eb 7f                	jmp    80108c04 <copyout+0x91>
  {
    va0 = (uint)PGROUNDDOWN(va);
80108b85:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char *)va0);
80108b90:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b93:	83 ec 08             	sub    $0x8,%esp
80108b96:	50                   	push   %eax
80108b97:	ff 75 08             	pushl  0x8(%ebp)
80108b9a:	e8 7b ff ff ff       	call   80108b1a <uva2ka>
80108b9f:	83 c4 10             	add    $0x10,%esp
80108ba2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (pa0 == 0)
80108ba5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108ba9:	75 07                	jne    80108bb2 <copyout+0x3f>
    {
      // p4Debug : Cannot find page in kernel space.
      return -1;
80108bab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108bb0:	eb 61                	jmp    80108c13 <copyout+0xa0>
    }
    n = PGSIZE - (va - va0);
80108bb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bb5:	2b 45 0c             	sub    0xc(%ebp),%eax
80108bb8:	05 00 10 00 00       	add    $0x1000,%eax
80108bbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (n > len)
80108bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bc3:	3b 45 14             	cmp    0x14(%ebp),%eax
80108bc6:	76 06                	jbe    80108bce <copyout+0x5b>
      n = len;
80108bc8:	8b 45 14             	mov    0x14(%ebp),%eax
80108bcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108bce:	8b 45 0c             	mov    0xc(%ebp),%eax
80108bd1:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108bd4:	89 c2                	mov    %eax,%edx
80108bd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108bd9:	01 d0                	add    %edx,%eax
80108bdb:	83 ec 04             	sub    $0x4,%esp
80108bde:	ff 75 f0             	pushl  -0x10(%ebp)
80108be1:	ff 75 f4             	pushl  -0xc(%ebp)
80108be4:	50                   	push   %eax
80108be5:	e8 28 cd ff ff       	call   80105912 <memmove>
80108bea:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bf0:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bf6:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108bf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bfc:	05 00 10 00 00       	add    $0x1000,%eax
80108c01:	89 45 0c             	mov    %eax,0xc(%ebp)
  while (len > 0)
80108c04:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108c08:	0f 85 77 ff ff ff    	jne    80108b85 <copyout+0x12>
  }
  return 0;
80108c0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108c13:	c9                   	leave  
80108c14:	c3                   	ret    

80108c15 <translate_and_set>:

// This function is just like uva2ka but sets the PTE_E bit and clears PTE_P
char *translate_and_set(pde_t *pgdir, char *uva)
{
80108c15:	f3 0f 1e fb          	endbr32 
80108c19:	55                   	push   %ebp
80108c1a:	89 e5                	mov    %esp,%ebp
80108c1c:	83 ec 18             	sub    $0x18,%esp
  cprintf("p4Debug: setting PTE_E for %p, VPN %d\n", uva, PPN(uva));
80108c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c22:	c1 e8 0c             	shr    $0xc,%eax
80108c25:	83 ec 04             	sub    $0x4,%esp
80108c28:	50                   	push   %eax
80108c29:	ff 75 0c             	pushl  0xc(%ebp)
80108c2c:	68 f8 9f 10 80       	push   $0x80109ff8
80108c31:	e8 e2 77 ff ff       	call   80100418 <cprintf>
80108c36:	83 c4 10             	add    $0x10,%esp
  pte_t *pte;
  pte = walkpgdir(pgdir, uva, 0);
80108c39:	83 ec 04             	sub    $0x4,%esp
80108c3c:	6a 00                	push   $0x0
80108c3e:	ff 75 0c             	pushl  0xc(%ebp)
80108c41:	ff 75 08             	pushl  0x8(%ebp)
80108c44:	e8 ed f5 ff ff       	call   80108236 <walkpgdir>
80108c49:	83 c4 10             	add    $0x10,%esp
80108c4c:	89 45 f4             	mov    %eax,-0xc(%ebp)

  // p4Debug: If page is not present AND it is not encrypted.
  if ((*pte & PTE_P) == 0 && (*pte & PTE_E) == 0)
80108c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c52:	8b 00                	mov    (%eax),%eax
80108c54:	83 e0 01             	and    $0x1,%eax
80108c57:	85 c0                	test   %eax,%eax
80108c59:	75 18                	jne    80108c73 <translate_and_set+0x5e>
80108c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c5e:	8b 00                	mov    (%eax),%eax
80108c60:	25 00 04 00 00       	and    $0x400,%eax
80108c65:	85 c0                	test   %eax,%eax
80108c67:	75 0a                	jne    80108c73 <translate_and_set+0x5e>
    return 0;
80108c69:	b8 00 00 00 00       	mov    $0x0,%eax
80108c6e:	e9 84 00 00 00       	jmp    80108cf7 <translate_and_set+0xe2>
  // p4Debug: If page is already encrypted, i.e. PTE_E is set, return NULL as error;
  if ((*pte & PTE_E))
80108c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c76:	8b 00                	mov    (%eax),%eax
80108c78:	25 00 04 00 00       	and    $0x400,%eax
80108c7d:	85 c0                	test   %eax,%eax
80108c7f:	74 07                	je     80108c88 <translate_and_set+0x73>
  {
    return 0;
80108c81:	b8 00 00 00 00       	mov    $0x0,%eax
80108c86:	eb 6f                	jmp    80108cf7 <translate_and_set+0xe2>
  }
  // p4Debug: Check if users are allowed to use this page
  if ((*pte & PTE_U) == 0)
80108c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c8b:	8b 00                	mov    (%eax),%eax
80108c8d:	83 e0 04             	and    $0x4,%eax
80108c90:	85 c0                	test   %eax,%eax
80108c92:	75 07                	jne    80108c9b <translate_and_set+0x86>
    return 0;
80108c94:	b8 00 00 00 00       	mov    $0x0,%eax
80108c99:	eb 5c                	jmp    80108cf7 <translate_and_set+0xe2>
  // p4Debug: Set Page as encrypted and not present so that we can trap(see trap.c) to decrypt page
  cprintf("p4Debug: PTE was %x and its pointer %p\n", *pte, pte);
80108c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c9e:	8b 00                	mov    (%eax),%eax
80108ca0:	83 ec 04             	sub    $0x4,%esp
80108ca3:	ff 75 f4             	pushl  -0xc(%ebp)
80108ca6:	50                   	push   %eax
80108ca7:	68 20 a0 10 80       	push   $0x8010a020
80108cac:	e8 67 77 ff ff       	call   80100418 <cprintf>
80108cb1:	83 c4 10             	add    $0x10,%esp
  *pte = *pte | PTE_E;
80108cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cb7:	8b 00                	mov    (%eax),%eax
80108cb9:	80 cc 04             	or     $0x4,%ah
80108cbc:	89 c2                	mov    %eax,%edx
80108cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cc1:	89 10                	mov    %edx,(%eax)
  *pte = *pte & ~PTE_P;
80108cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cc6:	8b 00                	mov    (%eax),%eax
80108cc8:	83 e0 fe             	and    $0xfffffffe,%eax
80108ccb:	89 c2                	mov    %eax,%edx
80108ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cd0:	89 10                	mov    %edx,(%eax)
  cprintf("p4Debug: PTE is now %x\n", *pte);
80108cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cd5:	8b 00                	mov    (%eax),%eax
80108cd7:	83 ec 08             	sub    $0x8,%esp
80108cda:	50                   	push   %eax
80108cdb:	68 48 a0 10 80       	push   $0x8010a048
80108ce0:	e8 33 77 ff ff       	call   80100418 <cprintf>
80108ce5:	83 c4 10             	add    $0x10,%esp
  return (char *)P2V(PTE_ADDR(*pte));
80108ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ceb:	8b 00                	mov    (%eax),%eax
80108ced:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108cf2:	05 00 00 00 80       	add    $0x80000000,%eax
}
80108cf7:	c9                   	leave  
80108cf8:	c3                   	ret    

80108cf9 <mdecrypt>:

int count = 0;

int mdecrypt(char *virtual_addr)
{
80108cf9:	f3 0f 1e fb          	endbr32 
80108cfd:	55                   	push   %ebp
80108cfe:	89 e5                	mov    %esp,%ebp
80108d00:	53                   	push   %ebx
80108d01:	83 ec 44             	sub    $0x44,%esp
  cprintf("p4Debug:  mdecrypt VPN %d, %p, pid %d\n", PPN(virtual_addr), virtual_addr, myproc()->pid);
80108d04:	e8 4d b8 ff ff       	call   80104556 <myproc>
80108d09:	8b 40 10             	mov    0x10(%eax),%eax
80108d0c:	8b 55 08             	mov    0x8(%ebp),%edx
80108d0f:	c1 ea 0c             	shr    $0xc,%edx
80108d12:	50                   	push   %eax
80108d13:	ff 75 08             	pushl  0x8(%ebp)
80108d16:	52                   	push   %edx
80108d17:	68 60 a0 10 80       	push   $0x8010a060
80108d1c:	e8 f7 76 ff ff       	call   80100418 <cprintf>
80108d21:	83 c4 10             	add    $0x10,%esp
  // p4Debug: virtual_addr is a virtual address in this PID's userspace.
  struct proc *p = myproc();
80108d24:	e8 2d b8 ff ff       	call   80104556 <myproc>
80108d29:	89 45 e0             	mov    %eax,-0x20(%ebp)
  pde_t *mypd = p->pgdir;
80108d2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108d2f:	8b 40 04             	mov    0x4(%eax),%eax
80108d32:	89 45 dc             	mov    %eax,-0x24(%ebp)
  // set the present bit to true and encrypt bit to false
  pte_t *pte = walkpgdir(mypd, virtual_addr, 0);
80108d35:	83 ec 04             	sub    $0x4,%esp
80108d38:	6a 00                	push   $0x0
80108d3a:	ff 75 08             	pushl  0x8(%ebp)
80108d3d:	ff 75 dc             	pushl  -0x24(%ebp)
80108d40:	e8 f1 f4 ff ff       	call   80108236 <walkpgdir>
80108d45:	83 c4 10             	add    $0x10,%esp
80108d48:	89 45 d8             	mov    %eax,-0x28(%ebp)

  cprintf("p4Debug: pte IS %x\n", *pte);
80108d4b:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108d4e:	8b 00                	mov    (%eax),%eax
80108d50:	83 ec 08             	sub    $0x8,%esp
80108d53:	50                   	push   %eax
80108d54:	68 87 a0 10 80       	push   $0x8010a087
80108d59:	e8 ba 76 ff ff       	call   80100418 <cprintf>
80108d5e:	83 c4 10             	add    $0x10,%esp

  if (!(*pte & PTE_E))
80108d61:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108d64:	8b 00                	mov    (%eax),%eax
80108d66:	25 00 04 00 00       	and    $0x400,%eax
80108d6b:	85 c0                	test   %eax,%eax
80108d6d:	75 0a                	jne    80108d79 <mdecrypt+0x80>
  {
    return -1;
80108d6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108d74:	e9 6c 03 00 00       	jmp    801090e5 <mdecrypt+0x3ec>
  }

  cprintf("mdecrypt: 2\n");
80108d79:	83 ec 0c             	sub    $0xc,%esp
80108d7c:	68 9b a0 10 80       	push   $0x8010a09b
80108d81:	e8 92 76 ff ff       	call   80100418 <cprintf>
80108d86:	83 c4 10             	add    $0x10,%esp

  if (!pte || (*pte & PTE_U) == 0)
80108d89:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80108d8d:	74 0c                	je     80108d9b <mdecrypt+0xa2>
80108d8f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108d92:	8b 00                	mov    (%eax),%eax
80108d94:	83 e0 04             	and    $0x4,%eax
80108d97:	85 c0                	test   %eax,%eax
80108d99:	75 0a                	jne    80108da5 <mdecrypt+0xac>
    return -1;
80108d9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108da0:	e9 40 03 00 00       	jmp    801090e5 <mdecrypt+0x3ec>

  cprintf("mdecrypt: 3\n");
80108da5:	83 ec 0c             	sub    $0xc,%esp
80108da8:	68 a8 a0 10 80       	push   $0x8010a0a8
80108dad:	e8 66 76 ff ff       	call   80100418 <cprintf>
80108db2:	83 c4 10             	add    $0x10,%esp

  if (!pte || *pte == 0)
80108db5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80108db9:	74 09                	je     80108dc4 <mdecrypt+0xcb>
80108dbb:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108dbe:	8b 00                	mov    (%eax),%eax
80108dc0:	85 c0                	test   %eax,%eax
80108dc2:	75 1a                	jne    80108dde <mdecrypt+0xe5>
  {
    cprintf("p4Debug: walkpgdir failed\n");
80108dc4:	83 ec 0c             	sub    $0xc,%esp
80108dc7:	68 b5 a0 10 80       	push   $0x8010a0b5
80108dcc:	e8 47 76 ff ff       	call   80100418 <cprintf>
80108dd1:	83 c4 10             	add    $0x10,%esp
    return -1;
80108dd4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108dd9:	e9 07 03 00 00       	jmp    801090e5 <mdecrypt+0x3ec>
  }
  cprintf("p4Debug: pte was %x\n", *pte);
80108dde:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108de1:	8b 00                	mov    (%eax),%eax
80108de3:	83 ec 08             	sub    $0x8,%esp
80108de6:	50                   	push   %eax
80108de7:	68 d0 a0 10 80       	push   $0x8010a0d0
80108dec:	e8 27 76 ff ff       	call   80100418 <cprintf>
80108df1:	83 c4 10             	add    $0x10,%esp
  *pte = *pte & ~PTE_E;
80108df4:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108df7:	8b 00                	mov    (%eax),%eax
80108df9:	80 e4 fb             	and    $0xfb,%ah
80108dfc:	89 c2                	mov    %eax,%edx
80108dfe:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108e01:	89 10                	mov    %edx,(%eax)
  *pte = *pte | PTE_P;
80108e03:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108e06:	8b 00                	mov    (%eax),%eax
80108e08:	83 c8 01             	or     $0x1,%eax
80108e0b:	89 c2                	mov    %eax,%edx
80108e0d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108e10:	89 10                	mov    %edx,(%eax)
  cprintf("p4Debug: pte is %x\n", *pte);
80108e12:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108e15:	8b 00                	mov    (%eax),%eax
80108e17:	83 ec 08             	sub    $0x8,%esp
80108e1a:	50                   	push   %eax
80108e1b:	68 e5 a0 10 80       	push   $0x8010a0e5
80108e20:	e8 f3 75 ff ff       	call   80100418 <cprintf>
80108e25:	83 c4 10             	add    $0x10,%esp
  char *original = uva2ka(mypd, virtual_addr) + OFFSET(virtual_addr);
80108e28:	83 ec 08             	sub    $0x8,%esp
80108e2b:	ff 75 08             	pushl  0x8(%ebp)
80108e2e:	ff 75 dc             	pushl  -0x24(%ebp)
80108e31:	e8 e4 fc ff ff       	call   80108b1a <uva2ka>
80108e36:	83 c4 10             	add    $0x10,%esp
80108e39:	8b 55 08             	mov    0x8(%ebp),%edx
80108e3c:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
80108e42:	01 d0                	add    %edx,%eax
80108e44:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  cprintf("p4Debug: Original in decrypt was %p\n", original);
80108e47:	83 ec 08             	sub    $0x8,%esp
80108e4a:	ff 75 d4             	pushl  -0x2c(%ebp)
80108e4d:	68 fc a0 10 80       	push   $0x8010a0fc
80108e52:	e8 c1 75 ff ff       	call   80100418 <cprintf>
80108e57:	83 c4 10             	add    $0x10,%esp
  virtual_addr = (char *)PGROUNDDOWN((uint)virtual_addr);
80108e5a:	8b 45 08             	mov    0x8(%ebp),%eax
80108e5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108e62:	89 45 08             	mov    %eax,0x8(%ebp)
  cprintf("p4Debug: mdecrypt: rounded down va is %p\n", virtual_addr);
80108e65:	83 ec 08             	sub    $0x8,%esp
80108e68:	ff 75 08             	pushl  0x8(%ebp)
80108e6b:	68 24 a1 10 80       	push   $0x8010a124
80108e70:	e8 a3 75 ff ff       	call   80100418 <cprintf>
80108e75:	83 c4 10             	add    $0x10,%esp

  char *kvp = uva2ka(mypd, virtual_addr);
80108e78:	83 ec 08             	sub    $0x8,%esp
80108e7b:	ff 75 08             	pushl  0x8(%ebp)
80108e7e:	ff 75 dc             	pushl  -0x24(%ebp)
80108e81:	e8 94 fc ff ff       	call   80108b1a <uva2ka>
80108e86:	83 c4 10             	add    $0x10,%esp
80108e89:	89 45 d0             	mov    %eax,-0x30(%ebp)
  if (!kvp || *kvp == 0)
80108e8c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
80108e90:	74 0a                	je     80108e9c <mdecrypt+0x1a3>
80108e92:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108e95:	0f b6 00             	movzbl (%eax),%eax
80108e98:	84 c0                	test   %al,%al
80108e9a:	75 0a                	jne    80108ea6 <mdecrypt+0x1ad>
  {
    return -1;
80108e9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108ea1:	e9 3f 02 00 00       	jmp    801090e5 <mdecrypt+0x3ec>
  }
  char *slider = virtual_addr;
80108ea6:	8b 45 08             	mov    0x8(%ebp),%eax
80108ea9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for (int offset = 0; offset < PGSIZE; offset++)
80108eac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108eb3:	eb 17                	jmp    80108ecc <mdecrypt+0x1d3>
  {
    *slider = *slider ^ 0xFF;
80108eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eb8:	0f b6 00             	movzbl (%eax),%eax
80108ebb:	f7 d0                	not    %eax
80108ebd:	89 c2                	mov    %eax,%edx
80108ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ec2:	88 10                	mov    %dl,(%eax)
    slider++;
80108ec4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  for (int offset = 0; offset < PGSIZE; offset++)
80108ec8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108ecc:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80108ed3:	7e e0                	jle    80108eb5 <mdecrypt+0x1bc>
  }

  // clock logic -----------------------------
  pde_t *mypdC = myproc()->pgdir;
80108ed5:	e8 7c b6 ff ff       	call   80104556 <myproc>
80108eda:	8b 40 04             	mov    0x4(%eax),%eax
80108edd:	89 45 cc             	mov    %eax,-0x34(%ebp)

  struct node add;

  // setting pageAddr so that it points to the start of the page that the given addr is on
  add.pageAddr = (char *)PGROUNDDOWN((uint)virtual_addr);
80108ee0:	8b 45 08             	mov    0x8(%ebp),%eax
80108ee3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108ee8:	89 45 bc             	mov    %eax,-0x44(%ebp)

  // if there is nothing in the clock queue yet
  if (myproc()->inClock == 0)
80108eeb:	e8 66 b6 ff ff       	call   80104556 <myproc>
80108ef0:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
80108ef6:	85 c0                	test   %eax,%eax
80108ef8:	75 31                	jne    80108f2b <mdecrypt+0x232>
  {

    myproc()->nodes[0].pageAddr = add.pageAddr;
80108efa:	e8 57 b6 ff ff       	call   80104556 <myproc>
80108eff:	8b 55 bc             	mov    -0x44(%ebp),%edx
80108f02:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
    myproc()->inClock = 1;
80108f08:	e8 49 b6 ff ff       	call   80104556 <myproc>
80108f0d:	c7 80 dc 00 00 00 01 	movl   $0x1,0xdc(%eax)
80108f14:	00 00 00 
    myproc()->currInd = 1;
80108f17:	e8 3a b6 ff ff       	call   80104556 <myproc>
80108f1c:	c7 80 e0 00 00 00 01 	movl   $0x1,0xe0(%eax)
80108f23:	00 00 00 
80108f26:	e9 a4 01 00 00       	jmp    801090cf <mdecrypt+0x3d6>
  }
  // if there is something in the queue
  else
  {
    // if the clock queue is not full
    if (myproc()->inClock < CLOCKSIZE)
80108f2b:	e8 26 b6 ff ff       	call   80104556 <myproc>
80108f30:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
80108f36:	83 f8 07             	cmp    $0x7,%eax
80108f39:	7f 5e                	jg     80108f99 <mdecrypt+0x2a0>
    {

      myproc()->nodes[myproc()->currInd] = add;
80108f3b:	e8 16 b6 ff ff       	call   80104556 <myproc>
80108f40:	89 c3                	mov    %eax,%ebx
80108f42:	e8 0f b6 ff ff       	call   80104556 <myproc>
80108f47:	8b 90 e0 00 00 00    	mov    0xe0(%eax),%edx
80108f4d:	89 d0                	mov    %edx,%eax
80108f4f:	01 c0                	add    %eax,%eax
80108f51:	01 d0                	add    %edx,%eax
80108f53:	c1 e0 02             	shl    $0x2,%eax
80108f56:	01 d8                	add    %ebx,%eax
80108f58:	83 c0 7c             	add    $0x7c,%eax
80108f5b:	8b 55 b8             	mov    -0x48(%ebp),%edx
80108f5e:	89 10                	mov    %edx,(%eax)
80108f60:	8b 55 bc             	mov    -0x44(%ebp),%edx
80108f63:	89 50 04             	mov    %edx,0x4(%eax)
80108f66:	8b 55 c0             	mov    -0x40(%ebp),%edx
80108f69:	89 50 08             	mov    %edx,0x8(%eax)
      myproc()->currInd++;
80108f6c:	e8 e5 b5 ff ff       	call   80104556 <myproc>
80108f71:	8b 90 e0 00 00 00    	mov    0xe0(%eax),%edx
80108f77:	83 c2 01             	add    $0x1,%edx
80108f7a:	89 90 e0 00 00 00    	mov    %edx,0xe0(%eax)
      myproc()->inClock++;
80108f80:	e8 d1 b5 ff ff       	call   80104556 <myproc>
80108f85:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
80108f8b:	83 c2 01             	add    $0x1,%edx
80108f8e:	89 90 dc 00 00 00    	mov    %edx,0xdc(%eax)
80108f94:	e9 36 01 00 00       	jmp    801090cf <mdecrypt+0x3d6>
      
    }
    // if the queue is full - need to evict
    else
    {
      cprintf("CASE 3\n");
80108f99:	83 ec 0c             	sub    $0xc,%esp
80108f9c:	68 4e a1 10 80       	push   $0x8010a14e
80108fa1:	e8 72 74 ff ff       	call   80100418 <cprintf>
80108fa6:	83 c4 10             	add    $0x10,%esp

      int evicted = 0;
80108fa9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

      // iterate through the queue at most 2 times because that is most amount needed
      for (int j = 0; j < 2; j++)
80108fb0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80108fb7:	e9 06 01 00 00       	jmp    801090c2 <mdecrypt+0x3c9>
      {

        for (int i = 0; i < CLOCKSIZE; i++)
80108fbc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80108fc3:	e9 e6 00 00 00       	jmp    801090ae <mdecrypt+0x3b5>
        {
          int realInd = (i + myproc()->currInd) % CLOCKSIZE;
80108fc8:	e8 89 b5 ff ff       	call   80104556 <myproc>
80108fcd:	8b 90 e0 00 00 00    	mov    0xe0(%eax),%edx
80108fd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108fd6:	01 c2                	add    %eax,%edx
80108fd8:	89 d0                	mov    %edx,%eax
80108fda:	c1 f8 1f             	sar    $0x1f,%eax
80108fdd:	c1 e8 1d             	shr    $0x1d,%eax
80108fe0:	01 c2                	add    %eax,%edx
80108fe2:	83 e2 07             	and    $0x7,%edx
80108fe5:	29 c2                	sub    %eax,%edx
80108fe7:	89 d0                	mov    %edx,%eax
80108fe9:	89 45 c8             	mov    %eax,-0x38(%ebp)

          // get the next pte from the pgtable
          pte_t *mypteC = walkpgdir(mypdC, myproc()->nodes[realInd].pageAddr, 0); //
80108fec:	e8 65 b5 ff ff       	call   80104556 <myproc>
80108ff1:	89 c1                	mov    %eax,%ecx
80108ff3:	8b 55 c8             	mov    -0x38(%ebp),%edx
80108ff6:	89 d0                	mov    %edx,%eax
80108ff8:	01 c0                	add    %eax,%eax
80108ffa:	01 d0                	add    %edx,%eax
80108ffc:	c1 e0 02             	shl    $0x2,%eax
80108fff:	01 c8                	add    %ecx,%eax
80109001:	83 e8 80             	sub    $0xffffff80,%eax
80109004:	8b 00                	mov    (%eax),%eax
80109006:	83 ec 04             	sub    $0x4,%esp
80109009:	6a 00                	push   $0x0
8010900b:	50                   	push   %eax
8010900c:	ff 75 cc             	pushl  -0x34(%ebp)
8010900f:	e8 22 f2 ff ff       	call   80108236 <walkpgdir>
80109014:	83 c4 10             	add    $0x10,%esp
80109017:	89 45 c4             	mov    %eax,-0x3c(%ebp)

          // the ref bit is not 0, so set it to 0 and move to the next node
          if (*mypteC & PTE_A)
8010901a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010901d:	8b 00                	mov    (%eax),%eax
8010901f:	83 e0 20             	and    $0x20,%eax
80109022:	85 c0                	test   %eax,%eax
80109024:	74 11                	je     80109037 <mdecrypt+0x33e>
          {
            // change PTE_A to 0 so we can see if the page has been accessed again once we loop back to this node
            *mypteC = *mypteC & ~PTE_A;
80109026:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80109029:	8b 00                	mov    (%eax),%eax
8010902b:	83 e0 df             	and    $0xffffffdf,%eax
8010902e:	89 c2                	mov    %eax,%edx
80109030:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80109033:	89 10                	mov    %edx,(%eax)
80109035:	eb 73                	jmp    801090aa <mdecrypt+0x3b1>
          }
          else
          {

            // encrypt the evicted address
            mencrypt(myproc()->nodes[realInd].pageAddr, 1);
80109037:	e8 1a b5 ff ff       	call   80104556 <myproc>
8010903c:	89 c1                	mov    %eax,%ecx
8010903e:	8b 55 c8             	mov    -0x38(%ebp),%edx
80109041:	89 d0                	mov    %edx,%eax
80109043:	01 c0                	add    %eax,%eax
80109045:	01 d0                	add    %edx,%eax
80109047:	c1 e0 02             	shl    $0x2,%eax
8010904a:	01 c8                	add    %ecx,%eax
8010904c:	83 e8 80             	sub    $0xffffff80,%eax
8010904f:	8b 00                	mov    (%eax),%eax
80109051:	83 ec 08             	sub    $0x8,%esp
80109054:	6a 01                	push   $0x1
80109056:	50                   	push   %eax
80109057:	e8 8e 00 00 00       	call   801090ea <mencrypt>
8010905c:	83 c4 10             	add    $0x10,%esp

            myproc()->nodes[realInd].pageAddr = add.pageAddr;
8010905f:	e8 f2 b4 ff ff       	call   80104556 <myproc>
80109064:	89 c3                	mov    %eax,%ebx
80109066:	8b 4d bc             	mov    -0x44(%ebp),%ecx
80109069:	8b 55 c8             	mov    -0x38(%ebp),%edx
8010906c:	89 d0                	mov    %edx,%eax
8010906e:	01 c0                	add    %eax,%eax
80109070:	01 d0                	add    %edx,%eax
80109072:	c1 e0 02             	shl    $0x2,%eax
80109075:	01 d8                	add    %ebx,%eax
80109077:	83 e8 80             	sub    $0xffffff80,%eax
8010907a:	89 08                	mov    %ecx,(%eax)
            myproc()->currInd = (realInd + 1) % CLOCKSIZE;
8010907c:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010907f:	8d 58 01             	lea    0x1(%eax),%ebx
80109082:	e8 cf b4 ff ff       	call   80104556 <myproc>
80109087:	89 c2                	mov    %eax,%edx
80109089:	89 d8                	mov    %ebx,%eax
8010908b:	c1 f8 1f             	sar    $0x1f,%eax
8010908e:	c1 e8 1d             	shr    $0x1d,%eax
80109091:	8d 0c 03             	lea    (%ebx,%eax,1),%ecx
80109094:	83 e1 07             	and    $0x7,%ecx
80109097:	29 c1                	sub    %eax,%ecx
80109099:	89 c8                	mov    %ecx,%eax
8010909b:	89 82 e0 00 00 00    	mov    %eax,0xe0(%edx)

            evicted = 1;
801090a1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)

            break;
801090a8:	eb 0e                	jmp    801090b8 <mdecrypt+0x3bf>
        for (int i = 0; i < CLOCKSIZE; i++)
801090aa:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801090ae:	83 7d e4 07          	cmpl   $0x7,-0x1c(%ebp)
801090b2:	0f 8e 10 ff ff ff    	jle    80108fc8 <mdecrypt+0x2cf>
          }
        }

        // don't do second loop if something has already been evicted
        if (evicted == 1)
801090b8:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
801090bc:	74 10                	je     801090ce <mdecrypt+0x3d5>
      for (int j = 0; j < 2; j++)
801090be:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
801090c2:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
801090c6:	0f 8e f0 fe ff ff    	jle    80108fbc <mdecrypt+0x2c3>
801090cc:	eb 01                	jmp    801090cf <mdecrypt+0x3d6>
          break;
801090ce:	90                   	nop
      }
    }
  }

  // clock logic -----------------------------
  switchuvm(myproc());
801090cf:	e8 82 b4 ff ff       	call   80104556 <myproc>
801090d4:	83 ec 0c             	sub    $0xc,%esp
801090d7:	50                   	push   %eax
801090d8:	e8 80 f3 ff ff       	call   8010845d <switchuvm>
801090dd:	83 c4 10             	add    $0x10,%esp

  return 0;
801090e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801090e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801090e8:	c9                   	leave  
801090e9:	c3                   	ret    

801090ea <mencrypt>:

int mencrypt(char *virtual_addr, int len)
{
801090ea:	f3 0f 1e fb          	endbr32 
801090ee:	55                   	push   %ebp
801090ef:	89 e5                	mov    %esp,%ebp
801090f1:	83 ec 38             	sub    $0x38,%esp
  cprintf("p4Debug: mencrypt: %p %d\n", virtual_addr, len);
801090f4:	83 ec 04             	sub    $0x4,%esp
801090f7:	ff 75 0c             	pushl  0xc(%ebp)
801090fa:	ff 75 08             	pushl  0x8(%ebp)
801090fd:	68 56 a1 10 80       	push   $0x8010a156
80109102:	e8 11 73 ff ff       	call   80100418 <cprintf>
80109107:	83 c4 10             	add    $0x10,%esp
  // the given pointer is a virtual address in this pid's userspace
  struct proc *p = myproc();
8010910a:	e8 47 b4 ff ff       	call   80104556 <myproc>
8010910f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  pde_t *mypd = p->pgdir; 
80109112:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109115:	8b 40 04             	mov    0x4(%eax),%eax
80109118:	89 45 e0             	mov    %eax,-0x20(%ebp)

  virtual_addr = (char *)PGROUNDDOWN((uint)virtual_addr);
8010911b:	8b 45 08             	mov    0x8(%ebp),%eax
8010911e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109123:	89 45 08             	mov    %eax,0x8(%ebp)

  // error checking first. all or nothing.
  char *slider = virtual_addr;
80109126:	8b 45 08             	mov    0x8(%ebp),%eax
80109129:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for (int i = 0; i < len; i++)
8010912c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80109133:	e9 e2 00 00 00       	jmp    8010921a <mencrypt+0x130>
  {

    cprintf("CHECK1 slider %p\n", slider);
80109138:	83 ec 08             	sub    $0x8,%esp
8010913b:	ff 75 f4             	pushl  -0xc(%ebp)
8010913e:	68 70 a1 10 80       	push   $0x8010a170
80109143:	e8 d0 72 ff ff       	call   80100418 <cprintf>
80109148:	83 c4 10             	add    $0x10,%esp

    pte_t *mypteT = walkpgdir(mypd, slider, 0);
8010914b:	83 ec 04             	sub    $0x4,%esp
8010914e:	6a 00                	push   $0x0
80109150:	ff 75 f4             	pushl  -0xc(%ebp)
80109153:	ff 75 e0             	pushl  -0x20(%ebp)
80109156:	e8 db f0 ff ff       	call   80108236 <walkpgdir>
8010915b:	83 c4 10             	add    $0x10,%esp
8010915e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if ((*mypteT & PTE_U) == 0)
80109161:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80109164:	8b 00                	mov    (%eax),%eax
80109166:	83 e0 04             	and    $0x4,%eax
80109169:	85 c0                	test   %eax,%eax
8010916b:	75 45                	jne    801091b2 <mencrypt+0xc8>
    {
      cprintf("NON USER PAGE FOUND at slider = %p\n", slider);
8010916d:	83 ec 08             	sub    $0x8,%esp
80109170:	ff 75 f4             	pushl  -0xc(%ebp)
80109173:	68 84 a1 10 80       	push   $0x8010a184
80109178:	e8 9b 72 ff ff       	call   80100418 <cprintf>
8010917d:	83 c4 10             	add    $0x10,%esp
      cprintf("p4Debug: pte of BAD page is %x\n", *mypteT);
80109180:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80109183:	8b 00                	mov    (%eax),%eax
80109185:	83 ec 08             	sub    $0x8,%esp
80109188:	50                   	push   %eax
80109189:	68 a8 a1 10 80       	push   $0x8010a1a8
8010918e:	e8 85 72 ff ff       	call   80100418 <cprintf>
80109193:	83 c4 10             	add    $0x10,%esp
      slider += PGSIZE;
80109196:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
      cprintf("NON USER PAGE FOUND NEW SLIDER = %p\n", slider);
8010919d:	83 ec 08             	sub    $0x8,%esp
801091a0:	ff 75 f4             	pushl  -0xc(%ebp)
801091a3:	68 c8 a1 10 80       	push   $0x8010a1c8
801091a8:	e8 6b 72 ff ff       	call   80100418 <cprintf>
801091ad:	83 c4 10             	add    $0x10,%esp
      continue;
801091b0:	eb 64                	jmp    80109216 <mencrypt+0x12c>
    }

    // check page table for each translation first
    char *kvp = uva2ka(mypd, slider);
801091b2:	83 ec 08             	sub    $0x8,%esp
801091b5:	ff 75 f4             	pushl  -0xc(%ebp)
801091b8:	ff 75 e0             	pushl  -0x20(%ebp)
801091bb:	e8 5a f9 ff ff       	call   80108b1a <uva2ka>
801091c0:	83 c4 10             	add    $0x10,%esp
801091c3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    cprintf("p4Debug: slider %p, kvp for err check is %p\n", slider, kvp);
801091c6:	83 ec 04             	sub    $0x4,%esp
801091c9:	ff 75 d0             	pushl  -0x30(%ebp)
801091cc:	ff 75 f4             	pushl  -0xc(%ebp)
801091cf:	68 f0 a1 10 80       	push   $0x8010a1f0
801091d4:	e8 3f 72 ff ff       	call   80100418 <cprintf>
801091d9:	83 c4 10             	add    $0x10,%esp
    if (!kvp)
801091dc:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
801091e0:	75 1a                	jne    801091fc <mencrypt+0x112>
    {
      cprintf("p4Debug: mencrypt: kvp = NULL\n");
801091e2:	83 ec 0c             	sub    $0xc,%esp
801091e5:	68 20 a2 10 80       	push   $0x8010a220
801091ea:	e8 29 72 ff ff       	call   80100418 <cprintf>
801091ef:	83 c4 10             	add    $0x10,%esp
      return -1;
801091f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801091f7:	e9 26 01 00 00       	jmp    80109322 <mencrypt+0x238>
    }

    cprintf("SLIDER %p VALID\n", slider);
801091fc:	83 ec 08             	sub    $0x8,%esp
801091ff:	ff 75 f4             	pushl  -0xc(%ebp)
80109202:	68 3f a2 10 80       	push   $0x8010a23f
80109207:	e8 0c 72 ff ff       	call   80100418 <cprintf>
8010920c:	83 c4 10             	add    $0x10,%esp

    slider = slider + PGSIZE;
8010920f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  for (int i = 0; i < len; i++)
80109216:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010921a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010921d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109220:	0f 8c 12 ff ff ff    	jl     80109138 <mencrypt+0x4e>
  }

  // encrypt stage. Have to do this before setting flag
  // or else we'll page fault
  slider = virtual_addr;
80109226:	8b 45 08             	mov    0x8(%ebp),%eax
80109229:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for (int i = 0; i < len; i++)
8010922c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80109233:	e9 c8 00 00 00       	jmp    80109300 <mencrypt+0x216>
  {

    pte_t *mypte = walkpgdir(mypd, slider, 0);
80109238:	83 ec 04             	sub    $0x4,%esp
8010923b:	6a 00                	push   $0x0
8010923d:	ff 75 f4             	pushl  -0xc(%ebp)
80109240:	ff 75 e0             	pushl  -0x20(%ebp)
80109243:	e8 ee ef ff ff       	call   80108236 <walkpgdir>
80109248:	83 c4 10             	add    $0x10,%esp
8010924b:	89 45 dc             	mov    %eax,-0x24(%ebp)

    if ((*mypte & PTE_U) == 0)
8010924e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109251:	8b 00                	mov    (%eax),%eax
80109253:	83 e0 04             	and    $0x4,%eax
80109256:	85 c0                	test   %eax,%eax
80109258:	75 0c                	jne    80109266 <mencrypt+0x17c>
    {
      slider += PGSIZE;
8010925a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
      continue;
80109261:	e9 96 00 00 00       	jmp    801092fc <mencrypt+0x212>
    }

    if (*mypte & PTE_E)
80109266:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109269:	8b 00                	mov    (%eax),%eax
8010926b:	25 00 04 00 00       	and    $0x400,%eax
80109270:	85 c0                	test   %eax,%eax
80109272:	74 19                	je     8010928d <mencrypt+0x1a3>
    {
      cprintf("p4Debug: already encrypted\n");
80109274:	83 ec 0c             	sub    $0xc,%esp
80109277:	68 50 a2 10 80       	push   $0x8010a250
8010927c:	e8 97 71 ff ff       	call   80100418 <cprintf>
80109281:	83 c4 10             	add    $0x10,%esp
      slider += PGSIZE;
80109284:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
      continue;
8010928b:	eb 6f                	jmp    801092fc <mencrypt+0x212>
    }

    for (int offset = 0; offset < PGSIZE; offset++)
8010928d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80109294:	eb 17                	jmp    801092ad <mencrypt+0x1c3>
    {

      *slider = *slider ^ 0xFF;
80109296:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109299:	0f b6 00             	movzbl (%eax),%eax
8010929c:	f7 d0                	not    %eax
8010929e:	89 c2                	mov    %eax,%edx
801092a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092a3:	88 10                	mov    %dl,(%eax)
      slider++;
801092a5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    for (int offset = 0; offset < PGSIZE; offset++)
801092a9:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
801092ad:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
801092b4:	7e e0                	jle    80109296 <mencrypt+0x1ac>
    }

    *mypte = *mypte & ~PTE_A;
801092b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801092b9:	8b 00                	mov    (%eax),%eax
801092bb:	83 e0 df             	and    $0xffffffdf,%eax
801092be:	89 c2                	mov    %eax,%edx
801092c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801092c3:	89 10                	mov    %edx,(%eax)
    char *kvp_translated = translate_and_set(mypd, slider - PGSIZE);
801092c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092c8:	2d 00 10 00 00       	sub    $0x1000,%eax
801092cd:	83 ec 08             	sub    $0x8,%esp
801092d0:	50                   	push   %eax
801092d1:	ff 75 e0             	pushl  -0x20(%ebp)
801092d4:	e8 3c f9 ff ff       	call   80108c15 <translate_and_set>
801092d9:	83 c4 10             	add    $0x10,%esp
801092dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
    if (!kvp_translated)
801092df:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
801092e3:	75 17                	jne    801092fc <mencrypt+0x212>
    {
      cprintf("p4Debug: translate failed!");
801092e5:	83 ec 0c             	sub    $0xc,%esp
801092e8:	68 6c a2 10 80       	push   $0x8010a26c
801092ed:	e8 26 71 ff ff       	call   80100418 <cprintf>
801092f2:	83 c4 10             	add    $0x10,%esp
      return -1;
801092f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801092fa:	eb 26                	jmp    80109322 <mencrypt+0x238>
  for (int i = 0; i < len; i++)
801092fc:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80109300:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109303:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109306:	0f 8c 2c ff ff ff    	jl     80109238 <mencrypt+0x14e>
    }

  }

  switchuvm(myproc());
8010930c:	e8 45 b2 ff ff       	call   80104556 <myproc>
80109311:	83 ec 0c             	sub    $0xc,%esp
80109314:	50                   	push   %eax
80109315:	e8 43 f1 ff ff       	call   8010845d <switchuvm>
8010931a:	83 c4 10             	add    $0x10,%esp

  return 0;
8010931d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109322:	c9                   	leave  
80109323:	c3                   	ret    

80109324 <getpgtable>:

int getpgtable(struct pt_entry *pt_entries, int num, int wsetOnly)
{
80109324:	f3 0f 1e fb          	endbr32 
80109328:	55                   	push   %ebp
80109329:	89 e5                	mov    %esp,%ebp
8010932b:	83 ec 28             	sub    $0x28,%esp

  if (wsetOnly != 0 && wsetOnly != 1)
8010932e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80109332:	74 10                	je     80109344 <getpgtable+0x20>
80109334:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
80109338:	74 0a                	je     80109344 <getpgtable+0x20>
  {
    return -1; // wsetOnly is invalid, throw error
8010933a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010933f:	e9 0d 04 00 00       	jmp    80109751 <getpgtable+0x42d>
  }

  cprintf("p4Debug: getpgtable: %p, %d, %d\n", pt_entries, num, wsetOnly);
80109344:	ff 75 10             	pushl  0x10(%ebp)
80109347:	ff 75 0c             	pushl  0xc(%ebp)
8010934a:	ff 75 08             	pushl  0x8(%ebp)
8010934d:	68 88 a2 10 80       	push   $0x8010a288
80109352:	e8 c1 70 ff ff       	call   80100418 <cprintf>
80109357:	83 c4 10             	add    $0x10,%esp

  struct proc *curproc = myproc();
8010935a:	e8 f7 b1 ff ff       	call   80104556 <myproc>
8010935f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  pde_t *pgdir = curproc->pgdir;
80109362:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109365:	8b 40 04             	mov    0x4(%eax),%eax
80109368:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint uva = 0;
8010936b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if (curproc->sz % PGSIZE == 0)
80109372:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109375:	8b 00                	mov    (%eax),%eax
80109377:	25 ff 0f 00 00       	and    $0xfff,%eax
8010937c:	85 c0                	test   %eax,%eax
8010937e:	75 0f                	jne    8010938f <getpgtable+0x6b>
    uva = curproc->sz - PGSIZE;
80109380:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109383:	8b 00                	mov    (%eax),%eax
80109385:	2d 00 10 00 00       	sub    $0x1000,%eax
8010938a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010938d:	eb 0d                	jmp    8010939c <getpgtable+0x78>
  else
    uva = PGROUNDDOWN(curproc->sz);
8010938f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109392:	8b 00                	mov    (%eax),%eax
80109394:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109399:	89 45 f4             	mov    %eax,-0xc(%ebp)

  int i = 0;
8010939c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for (;; uva -= PGSIZE)
  {

    pte_t *pte = walkpgdir(pgdir, (const void *)uva, 0);
801093a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093a6:	83 ec 04             	sub    $0x4,%esp
801093a9:	6a 00                	push   $0x0
801093ab:	50                   	push   %eax
801093ac:	ff 75 e4             	pushl  -0x1c(%ebp)
801093af:	e8 82 ee ff ff       	call   80108236 <walkpgdir>
801093b4:	83 c4 10             	add    $0x10,%esp
801093b7:	89 45 e0             	mov    %eax,-0x20(%ebp)


    if (!(*pte & PTE_U) || !(*pte & (PTE_P | PTE_E)))
801093ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
801093bd:	8b 00                	mov    (%eax),%eax
801093bf:	83 e0 04             	and    $0x4,%eax
801093c2:	85 c0                	test   %eax,%eax
801093c4:	0f 84 77 03 00 00    	je     80109741 <getpgtable+0x41d>
801093ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
801093cd:	8b 00                	mov    (%eax),%eax
801093cf:	25 01 04 00 00       	and    $0x401,%eax
801093d4:	85 c0                	test   %eax,%eax
801093d6:	0f 84 65 03 00 00    	je     80109741 <getpgtable+0x41d>
      continue;

    // only add entries if they're present in clock
    if (wsetOnly == 1)
801093dc:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
801093e0:	0f 85 ef 01 00 00    	jne    801095d5 <getpgtable+0x2b1>
    {

      // check if pte is in the linked list
      for (int j = 0; j < myproc()->inClock; j++)
801093e6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801093ed:	e9 ca 01 00 00       	jmp    801095bc <getpgtable+0x298>
      {
        pte_t *temp = walkpgdir(pgdir, myproc()->nodes[j].pageAddr, 0);
801093f2:	e8 5f b1 ff ff       	call   80104556 <myproc>
801093f7:	89 c1                	mov    %eax,%ecx
801093f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
801093fc:	89 d0                	mov    %edx,%eax
801093fe:	01 c0                	add    %eax,%eax
80109400:	01 d0                	add    %edx,%eax
80109402:	c1 e0 02             	shl    $0x2,%eax
80109405:	01 c8                	add    %ecx,%eax
80109407:	83 e8 80             	sub    $0xffffff80,%eax
8010940a:	8b 00                	mov    (%eax),%eax
8010940c:	83 ec 04             	sub    $0x4,%esp
8010940f:	6a 00                	push   $0x0
80109411:	50                   	push   %eax
80109412:	ff 75 e4             	pushl  -0x1c(%ebp)
80109415:	e8 1c ee ff ff       	call   80108236 <walkpgdir>
8010941a:	83 c4 10             	add    $0x10,%esp
8010941d:	89 45 dc             	mov    %eax,-0x24(%ebp)

        // if equal is found, should add it to pt_entries
        if (pte == temp)
80109420:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109423:	3b 45 dc             	cmp    -0x24(%ebp),%eax
80109426:	0f 85 8c 01 00 00    	jne    801095b8 <getpgtable+0x294>
        {
          cprintf("p4Debug: equal found with address: %p\n", myproc()->nodes[j].pageAddr);
8010942c:	e8 25 b1 ff ff       	call   80104556 <myproc>
80109431:	89 c1                	mov    %eax,%ecx
80109433:	8b 55 ec             	mov    -0x14(%ebp),%edx
80109436:	89 d0                	mov    %edx,%eax
80109438:	01 c0                	add    %eax,%eax
8010943a:	01 d0                	add    %edx,%eax
8010943c:	c1 e0 02             	shl    $0x2,%eax
8010943f:	01 c8                	add    %ecx,%eax
80109441:	83 e8 80             	sub    $0xffffff80,%eax
80109444:	8b 00                	mov    (%eax),%eax
80109446:	83 ec 08             	sub    $0x8,%esp
80109449:	50                   	push   %eax
8010944a:	68 ac a2 10 80       	push   $0x8010a2ac
8010944f:	e8 c4 6f ff ff       	call   80100418 <cprintf>
80109454:	83 c4 10             	add    $0x10,%esp

          pt_entries[i].pdx = PDX(uva);
80109457:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010945a:	c1 e8 16             	shr    $0x16,%eax
8010945d:	89 c1                	mov    %eax,%ecx
8010945f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109462:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80109469:	8b 45 08             	mov    0x8(%ebp),%eax
8010946c:	01 c2                	add    %eax,%edx
8010946e:	89 c8                	mov    %ecx,%eax
80109470:	66 25 ff 03          	and    $0x3ff,%ax
80109474:	66 25 ff 03          	and    $0x3ff,%ax
80109478:	89 c1                	mov    %eax,%ecx
8010947a:	0f b7 02             	movzwl (%edx),%eax
8010947d:	66 25 00 fc          	and    $0xfc00,%ax
80109481:	09 c8                	or     %ecx,%eax
80109483:	66 89 02             	mov    %ax,(%edx)
          pt_entries[i].ptx = PTX(uva);
80109486:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109489:	c1 e8 0c             	shr    $0xc,%eax
8010948c:	89 c1                	mov    %eax,%ecx
8010948e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109491:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80109498:	8b 45 08             	mov    0x8(%ebp),%eax
8010949b:	01 c2                	add    %eax,%edx
8010949d:	89 c8                	mov    %ecx,%eax
8010949f:	66 25 ff 03          	and    $0x3ff,%ax
801094a3:	0f b7 c0             	movzwl %ax,%eax
801094a6:	25 ff 03 00 00       	and    $0x3ff,%eax
801094ab:	c1 e0 0a             	shl    $0xa,%eax
801094ae:	89 c1                	mov    %eax,%ecx
801094b0:	8b 02                	mov    (%edx),%eax
801094b2:	25 ff 03 f0 ff       	and    $0xfff003ff,%eax
801094b7:	09 c8                	or     %ecx,%eax
801094b9:	89 02                	mov    %eax,(%edx)
          pt_entries[i].ppage = *pte >> PTXSHIFT;
801094bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801094be:	8b 00                	mov    (%eax),%eax
801094c0:	c1 e8 0c             	shr    $0xc,%eax
801094c3:	89 c2                	mov    %eax,%edx
801094c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801094c8:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
801094cf:	8b 45 08             	mov    0x8(%ebp),%eax
801094d2:	01 c8                	add    %ecx,%eax
801094d4:	81 e2 ff ff 0f 00    	and    $0xfffff,%edx
801094da:	89 d1                	mov    %edx,%ecx
801094dc:	81 e1 ff ff 0f 00    	and    $0xfffff,%ecx
801094e2:	8b 50 04             	mov    0x4(%eax),%edx
801094e5:	81 e2 00 00 f0 ff    	and    $0xfff00000,%edx
801094eb:	09 ca                	or     %ecx,%edx
801094ed:	89 50 04             	mov    %edx,0x4(%eax)
          pt_entries[i].present = *pte & PTE_P;
801094f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801094f3:	8b 08                	mov    (%eax),%ecx
801094f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801094f8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801094ff:	8b 45 08             	mov    0x8(%ebp),%eax
80109502:	01 c2                	add    %eax,%edx
80109504:	89 c8                	mov    %ecx,%eax
80109506:	83 e0 01             	and    $0x1,%eax
80109509:	83 e0 01             	and    $0x1,%eax
8010950c:	c1 e0 04             	shl    $0x4,%eax
8010950f:	89 c1                	mov    %eax,%ecx
80109511:	0f b6 42 06          	movzbl 0x6(%edx),%eax
80109515:	83 e0 ef             	and    $0xffffffef,%eax
80109518:	09 c8                	or     %ecx,%eax
8010951a:	88 42 06             	mov    %al,0x6(%edx)
          pt_entries[i].writable = (*pte & PTE_W) > 0;
8010951d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109520:	8b 00                	mov    (%eax),%eax
80109522:	83 e0 02             	and    $0x2,%eax
80109525:	89 c2                	mov    %eax,%edx
80109527:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010952a:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80109531:	8b 45 08             	mov    0x8(%ebp),%eax
80109534:	01 c8                	add    %ecx,%eax
80109536:	85 d2                	test   %edx,%edx
80109538:	0f 95 c2             	setne  %dl
8010953b:	83 e2 01             	and    $0x1,%edx
8010953e:	89 d1                	mov    %edx,%ecx
80109540:	c1 e1 05             	shl    $0x5,%ecx
80109543:	0f b6 50 06          	movzbl 0x6(%eax),%edx
80109547:	83 e2 df             	and    $0xffffffdf,%edx
8010954a:	09 ca                	or     %ecx,%edx
8010954c:	88 50 06             	mov    %dl,0x6(%eax)
          pt_entries[i].encrypted = (*pte & PTE_E) > 0;
8010954f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109552:	8b 00                	mov    (%eax),%eax
80109554:	25 00 04 00 00       	and    $0x400,%eax
80109559:	89 c2                	mov    %eax,%edx
8010955b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010955e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80109565:	8b 45 08             	mov    0x8(%ebp),%eax
80109568:	01 c8                	add    %ecx,%eax
8010956a:	85 d2                	test   %edx,%edx
8010956c:	0f 95 c2             	setne  %dl
8010956f:	89 d1                	mov    %edx,%ecx
80109571:	c1 e1 07             	shl    $0x7,%ecx
80109574:	0f b6 50 06          	movzbl 0x6(%eax),%edx
80109578:	83 e2 7f             	and    $0x7f,%edx
8010957b:	09 ca                	or     %ecx,%edx
8010957d:	88 50 06             	mov    %dl,0x6(%eax)
          pt_entries[i].ref = (*pte & PTE_A) > 0;
80109580:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109583:	8b 00                	mov    (%eax),%eax
80109585:	83 e0 20             	and    $0x20,%eax
80109588:	89 c2                	mov    %eax,%edx
8010958a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010958d:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80109594:	8b 45 08             	mov    0x8(%ebp),%eax
80109597:	01 c8                	add    %ecx,%eax
80109599:	85 d2                	test   %edx,%edx
8010959b:	0f 95 c2             	setne  %dl
8010959e:	89 d1                	mov    %edx,%ecx
801095a0:	83 e1 01             	and    $0x1,%ecx
801095a3:	0f b6 50 07          	movzbl 0x7(%eax),%edx
801095a7:	83 e2 fe             	and    $0xfffffffe,%edx
801095aa:	09 ca                	or     %ecx,%edx
801095ac:	88 50 07             	mov    %dl,0x7(%eax)

          i++;
801095af:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)

          break;
801095b3:	e9 79 01 00 00       	jmp    80109731 <getpgtable+0x40d>
      for (int j = 0; j < myproc()->inClock; j++)
801095b8:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801095bc:	e8 95 af ff ff       	call   80104556 <myproc>
801095c1:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
801095c7:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801095ca:	0f 8c 22 fe ff ff    	jl     801093f2 <getpgtable+0xce>
801095d0:	e9 5c 01 00 00       	jmp    80109731 <getpgtable+0x40d>
        }
      }
    }
    else
    {
      pt_entries[i].pdx = PDX(uva);
801095d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095d8:	c1 e8 16             	shr    $0x16,%eax
801095db:	89 c1                	mov    %eax,%ecx
801095dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801095e0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801095e7:	8b 45 08             	mov    0x8(%ebp),%eax
801095ea:	01 c2                	add    %eax,%edx
801095ec:	89 c8                	mov    %ecx,%eax
801095ee:	66 25 ff 03          	and    $0x3ff,%ax
801095f2:	66 25 ff 03          	and    $0x3ff,%ax
801095f6:	89 c1                	mov    %eax,%ecx
801095f8:	0f b7 02             	movzwl (%edx),%eax
801095fb:	66 25 00 fc          	and    $0xfc00,%ax
801095ff:	09 c8                	or     %ecx,%eax
80109601:	66 89 02             	mov    %ax,(%edx)
      pt_entries[i].ptx = PTX(uva);
80109604:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109607:	c1 e8 0c             	shr    $0xc,%eax
8010960a:	89 c1                	mov    %eax,%ecx
8010960c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010960f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80109616:	8b 45 08             	mov    0x8(%ebp),%eax
80109619:	01 c2                	add    %eax,%edx
8010961b:	89 c8                	mov    %ecx,%eax
8010961d:	66 25 ff 03          	and    $0x3ff,%ax
80109621:	0f b7 c0             	movzwl %ax,%eax
80109624:	25 ff 03 00 00       	and    $0x3ff,%eax
80109629:	c1 e0 0a             	shl    $0xa,%eax
8010962c:	89 c1                	mov    %eax,%ecx
8010962e:	8b 02                	mov    (%edx),%eax
80109630:	25 ff 03 f0 ff       	and    $0xfff003ff,%eax
80109635:	09 c8                	or     %ecx,%eax
80109637:	89 02                	mov    %eax,(%edx)
      pt_entries[i].ppage = *pte >> PTXSHIFT;
80109639:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010963c:	8b 00                	mov    (%eax),%eax
8010963e:	c1 e8 0c             	shr    $0xc,%eax
80109641:	89 c2                	mov    %eax,%edx
80109643:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109646:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
8010964d:	8b 45 08             	mov    0x8(%ebp),%eax
80109650:	01 c8                	add    %ecx,%eax
80109652:	81 e2 ff ff 0f 00    	and    $0xfffff,%edx
80109658:	89 d1                	mov    %edx,%ecx
8010965a:	81 e1 ff ff 0f 00    	and    $0xfffff,%ecx
80109660:	8b 50 04             	mov    0x4(%eax),%edx
80109663:	81 e2 00 00 f0 ff    	and    $0xfff00000,%edx
80109669:	09 ca                	or     %ecx,%edx
8010966b:	89 50 04             	mov    %edx,0x4(%eax)
      pt_entries[i].present = *pte & PTE_P;
8010966e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109671:	8b 08                	mov    (%eax),%ecx
80109673:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109676:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
8010967d:	8b 45 08             	mov    0x8(%ebp),%eax
80109680:	01 c2                	add    %eax,%edx
80109682:	89 c8                	mov    %ecx,%eax
80109684:	83 e0 01             	and    $0x1,%eax
80109687:	83 e0 01             	and    $0x1,%eax
8010968a:	c1 e0 04             	shl    $0x4,%eax
8010968d:	89 c1                	mov    %eax,%ecx
8010968f:	0f b6 42 06          	movzbl 0x6(%edx),%eax
80109693:	83 e0 ef             	and    $0xffffffef,%eax
80109696:	09 c8                	or     %ecx,%eax
80109698:	88 42 06             	mov    %al,0x6(%edx)
      pt_entries[i].writable = (*pte & PTE_W) > 0;
8010969b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010969e:	8b 00                	mov    (%eax),%eax
801096a0:	83 e0 02             	and    $0x2,%eax
801096a3:	89 c2                	mov    %eax,%edx
801096a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801096a8:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
801096af:	8b 45 08             	mov    0x8(%ebp),%eax
801096b2:	01 c8                	add    %ecx,%eax
801096b4:	85 d2                	test   %edx,%edx
801096b6:	0f 95 c2             	setne  %dl
801096b9:	83 e2 01             	and    $0x1,%edx
801096bc:	89 d1                	mov    %edx,%ecx
801096be:	c1 e1 05             	shl    $0x5,%ecx
801096c1:	0f b6 50 06          	movzbl 0x6(%eax),%edx
801096c5:	83 e2 df             	and    $0xffffffdf,%edx
801096c8:	09 ca                	or     %ecx,%edx
801096ca:	88 50 06             	mov    %dl,0x6(%eax)
      pt_entries[i].encrypted = (*pte & PTE_E) > 0;
801096cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801096d0:	8b 00                	mov    (%eax),%eax
801096d2:	25 00 04 00 00       	and    $0x400,%eax
801096d7:	89 c2                	mov    %eax,%edx
801096d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801096dc:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
801096e3:	8b 45 08             	mov    0x8(%ebp),%eax
801096e6:	01 c8                	add    %ecx,%eax
801096e8:	85 d2                	test   %edx,%edx
801096ea:	0f 95 c2             	setne  %dl
801096ed:	89 d1                	mov    %edx,%ecx
801096ef:	c1 e1 07             	shl    $0x7,%ecx
801096f2:	0f b6 50 06          	movzbl 0x6(%eax),%edx
801096f6:	83 e2 7f             	and    $0x7f,%edx
801096f9:	09 ca                	or     %ecx,%edx
801096fb:	88 50 06             	mov    %dl,0x6(%eax)
      pt_entries[i].ref = (*pte & PTE_A) > 0;
801096fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109701:	8b 00                	mov    (%eax),%eax
80109703:	83 e0 20             	and    $0x20,%eax
80109706:	89 c2                	mov    %eax,%edx
80109708:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010970b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80109712:	8b 45 08             	mov    0x8(%ebp),%eax
80109715:	01 c8                	add    %ecx,%eax
80109717:	85 d2                	test   %edx,%edx
80109719:	0f 95 c2             	setne  %dl
8010971c:	89 d1                	mov    %edx,%ecx
8010971e:	83 e1 01             	and    $0x1,%ecx
80109721:	0f b6 50 07          	movzbl 0x7(%eax),%edx
80109725:	83 e2 fe             	and    $0xfffffffe,%edx
80109728:	09 ca                	or     %ecx,%edx
8010972a:	88 50 07             	mov    %dl,0x7(%eax)
      i++;
8010972d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    }

    if (uva == 0 || i == num)
80109731:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109735:	74 17                	je     8010974e <getpgtable+0x42a>
80109737:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010973a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010973d:	74 0f                	je     8010974e <getpgtable+0x42a>
8010973f:	eb 01                	jmp    80109742 <getpgtable+0x41e>
      continue;
80109741:	90                   	nop
  for (;; uva -= PGSIZE)
80109742:	81 6d f4 00 10 00 00 	subl   $0x1000,-0xc(%ebp)
  {
80109749:	e9 55 fc ff ff       	jmp    801093a3 <getpgtable+0x7f>
      break;
  }

  return i;
8010974e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80109751:	c9                   	leave  
80109752:	c3                   	ret    

80109753 <dump_rawphymem>:

int dump_rawphymem(char *physical_addr, char *buffer)
{
80109753:	f3 0f 1e fb          	endbr32 
80109757:	55                   	push   %ebp
80109758:	89 e5                	mov    %esp,%ebp
8010975a:	56                   	push   %esi
8010975b:	53                   	push   %ebx
8010975c:	83 ec 10             	sub    $0x10,%esp
  *buffer = *buffer;
8010975f:	8b 45 0c             	mov    0xc(%ebp),%eax
80109762:	0f b6 10             	movzbl (%eax),%edx
80109765:	8b 45 0c             	mov    0xc(%ebp),%eax
80109768:	88 10                	mov    %dl,(%eax)
  cprintf("p4Debug: dump_rawphymem: %p, %p\n", physical_addr, buffer);
8010976a:	83 ec 04             	sub    $0x4,%esp
8010976d:	ff 75 0c             	pushl  0xc(%ebp)
80109770:	ff 75 08             	pushl  0x8(%ebp)
80109773:	68 d4 a2 10 80       	push   $0x8010a2d4
80109778:	e8 9b 6c ff ff       	call   80100418 <cprintf>
8010977d:	83 c4 10             	add    $0x10,%esp
  int retval = copyout(myproc()->pgdir, (uint)buffer, (void *)PGROUNDDOWN((int)P2V(physical_addr)), PGSIZE);
80109780:	8b 45 08             	mov    0x8(%ebp),%eax
80109783:	05 00 00 00 80       	add    $0x80000000,%eax
80109788:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010978d:	89 c6                	mov    %eax,%esi
8010978f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80109792:	e8 bf ad ff ff       	call   80104556 <myproc>
80109797:	8b 40 04             	mov    0x4(%eax),%eax
8010979a:	68 00 10 00 00       	push   $0x1000
8010979f:	56                   	push   %esi
801097a0:	53                   	push   %ebx
801097a1:	50                   	push   %eax
801097a2:	e8 cc f3 ff ff       	call   80108b73 <copyout>
801097a7:	83 c4 10             	add    $0x10,%esp
801097aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (retval)
801097ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801097b1:	74 07                	je     801097ba <dump_rawphymem+0x67>
    return -1;
801097b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801097b8:	eb 05                	jmp    801097bf <dump_rawphymem+0x6c>
  return 0;
801097ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
801097bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801097c2:	5b                   	pop    %ebx
801097c3:	5e                   	pop    %esi
801097c4:	5d                   	pop    %ebp
801097c5:	c3                   	ret    
